// Testbench simulant un écran vidéo.
// Le testbench vérifie que les timings de synchro sont corrects
// Le testbench génère des images 

`include "vga_pkg.sv"
//if using standard clock (all verification is done at negedge)
//`define EDGE negedge 
//if using inverted clock (all verification is done at posedge)
`define EDGE posedge 
import vga_pkg::*;

class screendump #(X=640,Y=480);

bit  unsigned [7:0]   RVALUE[Y][X]='{default:'0};
bit  unsigned [7:0]   GVALUE[Y][X]='{default:'0};
bit  unsigned [7:0]   BVALUE[Y][X]='{default:'0};
string filename="screen_dump.ppm";
integer file;

function new();
	write_buf_to_file();
	//$system("display -update 1 screen_dump.ppm&");
endfunction

function void modify(logic[7:0] R ,logic[7:0] G, logic[7:0] B, integer x, integer y);
	RVALUE[y][x]=R;
	GVALUE[y][x]=G;
	BVALUE[y][x]=B;

endfunction

function void write_buf_to_file();
	integer i,j;
	file=$fopen(filename);
	//P3 for ascii text in ppm format, change to P6 for bianry
	$fwrite(file,"P3\n%0d %0d 255\n",X,Y);
	for (i=0;i<Y;i++) 
		for(j=0;j<X;j++)
			$fwrite(file,"%d %d %d \n",RVALUE[i][j],GVALUE[i][j],BVALUE[i][j]);
	$fclose(file);
endfunction

endclass

program screen #(mode=0,X=640,Y=480)
	(
    vga_if.slave vga_ifs
	);


parameter HDISP	=X;//vga_modes[mode][2]	;// h_active
parameter HFP	=vga_modes[mode][3]	;    // hfp
parameter HPULSE=vga_modes[mode][4]	;    // hp
parameter HBP	=vga_modes[mode][5]	;    // hbp
parameter VDISP	=Y;//vga_modes[mode][6]	;// v_active
parameter VFP	=vga_modes[mode][7]	;    // vfp
parameter VPULSE=vga_modes[mode][8]	;    // vp
parameter VBP	=vga_modes[mode][9]	;    // vbp

bit INTERNAL_CHECK_ENABLE ;


integer file;
integer frame_count=0;
integer row_count=0;
integer last_row_count,linedraw=0;
integer last_column_count,column_count=0;
//integer hfp,hbp,vfp,vbp;
bit in_vfp,in_vbp,in_vp,in_vdisp=1'b0;

function void f_in_vp(bit val);
in_vp=val;
endfunction

function void f_in_vbp(bit val);
in_vbp=val;
endfunction

function void f_in_vfp(bit val);
in_vfp=val;
endfunction

function void f_in_vdisp(bit val);
in_vdisp=val;
endfunction

logic [15:0] pixel;
string filename;
screendump#(X,Y) dump=new();


initial begin
fork 
	forever begin
		@(negedge vga_ifs.VGA_VS);
		row_count=0;
		frame_count++;
        	$display("dump de l'image :%d",frame_count) ;
		dump.write_buf_to_file();
        	@(posedge vga_ifs.VGA_VS);
        INTERNAL_CHECK_ENABLE = 1;
	end
	forever begin
		@(negedge vga_ifs.VGA_HS);
		column_count=0;
		if (in_vdisp) row_count++;
	end
	forever begin 
		@(`EDGE vga_ifs.VGA_CLK);
		if(in_vdisp && vga_ifs.VGA_BLANK) begin
			dump.modify(vga_ifs.VGA_R,vga_ifs.VGA_G,vga_ifs.VGA_B,column_count,row_count);
			column_count++;
		end
	end
join_any
end 
//-------horizontal timing is easy-------------------

property hdisp;
	@(`EDGE vga_ifs.VGA_CLK) 
	if(!(in_vfp||in_vbp||in_vp))
	if(INTERNAL_CHECK_ENABLE)
	$rose(vga_ifs.VGA_BLANK) |-> ##HDISP $fell(vga_ifs.VGA_BLANK);
endproperty

property hfp;
	@(`EDGE vga_ifs.VGA_CLK) 
	if(!(in_vfp||in_vbp||in_vp))
	if(INTERNAL_CHECK_ENABLE)
	($fell(vga_ifs.VGA_BLANK)) |-> ##HFP $fell(vga_ifs.VGA_HS);
endproperty

property hp;
	@(`EDGE vga_ifs.VGA_CLK) 
	if(!(in_vfp||in_vbp||in_vp))
	if(INTERNAL_CHECK_ENABLE)
	$fell(vga_ifs.VGA_HS) |-> ##HPULSE $rose(vga_ifs.VGA_HS);
endproperty

property hbp;
	@(`EDGE vga_ifs.VGA_CLK) 
	if(!(in_vfp||in_vbp||in_vp))
	//if(tb_fpga.fpga0.vga0.vga_enable)
	if(INTERNAL_CHECK_ENABLE)
	($rose(vga_ifs.VGA_HS)) |-> ##HBP $rose(vga_ifs.VGA_BLANK);
endproperty

assert property(hdisp)  else $error("HDISP mismatch /= %0d\n",X);
assert property(hfp)    else $fatal(1,"HFP   mismatch /= %0d\n", vga_modes[mode][3]);
assert property(hp)     else $fatal(1,"HP    mismatch /= %0d\n",vga_modes[mode][4]);
assert property(hbp)    else $fatal(1,"HBP   mismatch /= %0d\n",vga_modes[mode][5]);

//-------horizontal timing is easy-------------------

//-------vertical timing is a bit complicated, depends on previous sequence-------------------
sequence s_vp;
	($fell(vga_ifs.VGA_VS),f_in_vp(1)) ##0 ($rose(vga_ifs.VGA_HS)[->VPULSE],f_in_vp(0));

endsequence

property vp;
	@(`EDGE vga_ifs.VGA_CLK) 
 	s_vp |=> (first_match($rose(vga_ifs.VGA_VS)[->1])) ;	
	//we have to do this because only local vairables can be assigned within a sequence match,
	// but function calls are ok. in_vp=1, not_ok, f_in_vp(1) ok. why ?
endproperty

sequence s_vbp;
	$rose(vga_ifs.VGA_VS) ##0 ($rose(vga_ifs.VGA_HS)[->VBP]) ##0 ($rose(vga_ifs.VGA_BLANK)[->1],f_in_vbp(0));
endsequence

sequence s_vbp_1;
	~vga_ifs.VGA_BLANK throughout s_vbp;
endsequence

property vbp_1;
	@(`EDGE vga_ifs.VGA_CLK) 
	//if(tb_fpga.fpga0.vga0.vga_enable)
	if(INTERNAL_CHECK_ENABLE)
	($rose(vga_ifs.VGA_VS),f_in_vbp(1)) |-> (!vga_ifs.VGA_BLANK within s_vbp);
endproperty

property vbp;
	@(`EDGE vga_ifs.VGA_CLK) 
	if(INTERNAL_CHECK_ENABLE)
	//s_vbp |-> ($rose(vga_ifs.VGA_BLANK)[->1],f_in_vbp(0));
	($rose(vga_ifs.VGA_VS),f_in_vbp(1)) |-> s_vbp;
endproperty

sequence s_vdisp;
	$rose(vga_ifs.VGA_BLANK)[->VDISP];
endsequence

property vdisp;
	@(`EDGE vga_ifs.VGA_CLK) 
	//if(tb_fpga.fpga0.vga0.vga_enable)
	if(INTERNAL_CHECK_ENABLE)
	($rose(vga_ifs.VGA_VS)) |-> (s_vbp,f_in_vdisp(1)) |-> (s_vdisp,f_in_vdisp(0));
endproperty

sequence s_vfp;
	$rose(vga_ifs.VGA_HS)[->VFP] ##0 $fell(vga_ifs.VGA_VS)[->1];
endsequence

property vfp;
	@(`EDGE vga_ifs.VGA_CLK) 
	//if(tb_fpga.fpga0.vga0.vga_enable)
	if(INTERNAL_CHECK_ENABLE)
	($rose(vga_ifs.VGA_VS)) |-> (s_vbp) |-> (s_vdisp,f_in_vfp(1)) |->(s_vfp,f_in_vfp(0));
endproperty

assert property(vdisp)  else begin in_vdisp=0;  $error("VDISP mismatch /= %0d\n",Y); end
assert property(vfp)    else begin              $fatal(1,"VFP mismatch   /= %0d\n",vga_modes[mode][7]); end
assert property(vp)     else begin              $fatal(1,"VP mismatch    /= %0d\n",vga_modes[mode][8]); end
assert property(vbp)    else begin              $fatal(1,"VBP mismatch   /= %0d\n",vga_modes[mode][9]); end
assert property(vbp_1)  else begin              $fatal(1,"DISPLAY within VBP /= %0d\n",vga_modes[mode][9]); end
//assert property(not hbp)  $error("HBP not right\n");
//
endprogram
