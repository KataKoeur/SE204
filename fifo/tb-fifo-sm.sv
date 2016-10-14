// Testbench pour une FIFO esclave/maître

module tb_fifo_sm ;

// Choix de la profondeur de la fifo
parameter DEPTH_WIDTH = 4 ;
// Choix du nombre de données à transférer
parameter NBSAMPLE=4096 ;

bit clk, rst ;
logic [7:0] rdata;
logic [7:0] wdata ;
bit rready,wreq, rack,wack ;

fifo_sm  #(.DEPTH_WIDTH(DEPTH_WIDTH)) dut0 (.clk(clk),.rst(rst),.rdata(rdata),.wdata(wdata),.rready(rready),.wreq(wreq),.rack(rack),.wack(wack)) ;

initial begin
  forever #5 clk = ~clk ;
end
initial begin
  rst = 1 ;
  #20 ;
  rst = 0 ;
end

// Bus d'écriture aléatoire 256 écritures pour 1024 cycles

class write_signal ;
  rand  bit  write ;
  constraint c1 { write dist { 1:=(NBSAMPLE>>2), 0:=(NBSAMPLE-(NBSAMPLE>>2)) };}
endclass

class write_data ;
  rand  bit [7:0]  data ;
endclass

write_signal  wrs = new() ;
write_data    wrd = new() ;

int nb_w_sample  ;
initial
begin:w
  bit flag ;
  wreq = 0 ;
  wdata = '0 ;
  nb_w_sample = 0 ;
  @(negedge rst)
  forever 
  begin
    @(negedge clk) ;
    flag = wrs.randomize() ;
    if(wrs.write && nb_w_sample < NBSAMPLE)
    begin
      wreq = 1'b1 ;
      flag = wrd.randomize() ;
      wdata = wrd.data ;
        @(posedge clk) 
      while (~wack) @(posedge clk)  ;
      nb_w_sample++ ;
    end
    else 
      wreq = 1'b0 ;
  end
end

// Bus de lecture régulier 1 donnée tous les 4 cycles
bit [1:0] rdcount ;
int nb_r_sample  ;
initial
begin
  nb_r_sample = 0 ;
  @(negedge rst) ;
  forever
  begin
    @(negedge clk) ;
    rdcount++ ;
    if(rready && nb_r_sample < NBSAMPLE)
    begin
      if(rdcount==2'b11 )
      begin
        nb_r_sample++ ;
        rack = 1 ;
      end
      else
        rack = 0 ;
    end
    else
      rack = 0 ;
  end
end

// Statistiques sur la fifo et détection d'erreurs
logic signed [DEPTH_WIDTH+1:0] nbdata ;
initial
begin
  nbdata = 0 ;
  forever 
  begin
    @(posedge clk)
    nbdata = nbdata + wack - rack ;
    if((nbdata < 0) || (nbdata > 2**DEPTH_WIDTH)) 
    begin
      $display("Erreur dépassement dans la FIFO");
      $stop ;
    end
  end
end

// Vérification des données lues et ecrites
mailbox mbx = new() ;
always @(posedge clk)
  if(wack) 
    mbx.put(wdata) ;
logic [7:0] gdata ;
always @(posedge clk)
begin
  if(rack) 
  begin
    mbx.get(gdata) ;
    if(gdata != rdata) 
    begin
      $display("Erreur mauvaise donnée lue dans la fifo");
      $stop ;
    end
  end
end

// Statistiques sur l'usage de la FIFO
//int nbcycles ;
//int nb_full ;
//int nb_empty ;
//always @(posedge clk) 
//begin
//  if(rst)
//  begin
//    nbcycles <= 0 ;
//    nb_full <= 0 ;
//    nb_empty <= 0 ;
//  end
//  else 
//  begin
//    if(wfull ) nb_full++ ;
//    if(rempty ) nb_empty++ ;
//    nbcycles++ ;
//  end
//end

// Fin de la simu
always @(posedge clk)
  if(nb_r_sample == NBSAMPLE)
    begin
      $display("Fin de la simulation sans erreur");
      $display("%d donnees transmises",NBSAMPLE) ;
//      $display("%d cycles utilisés pour le transfert",nbcycles) ;
//      $display("%d cycles avec la FIFO vide",nb_empty) ;
//      $display("%d cycles avec la FIFO pleine",nb_full) ;
//      $display("durée moyenne d'un transfert : %f cycles/data",(nbcycles+0.0)/(NBSAMPLE+0.0)) ;
      $stop ;
    end


endmodule 
