`default_nettype none

module K2000 (
        ////////////////////////    50MHz Clock        ///////////////////////
        input logic            clock_50,        // 50 MHz
        input logic            reset_n,        // 50 MHz
        ////////////////////////////    LED        ///////////////////////////
        output logic  [9:0]    ledr,             //    LED Red[9:0]
        output logic  finishl,
        output logic  finishr,
        input logic  start
        );

   // Génération d'une horloge lente (0.5s de période)
   logic             clk;

    gene_clk gene_clkl(.clk_50(clock_50), .clk_out(clk));


    enum logic {aller,retour} sig;
    logic [17:0] ledtmp;

    always@(*)
    for (int i=0; i < 10; i++)
        ledr[i] <= ledtmp[i+4];


    always@(posedge clk )
    if(!reset_n) begin
        ledtmp <= 10'd7;
    end
    else
    begin
        case (sig)
        aller :
            begin
                if(start) begin
                    ledtmp[0] <= 1'b0;
                    for (int i=1; i<18; i++)
                        ledtmp[i] <= ledtmp[i-1];
                end
            end
        retour :
            begin
                if(start) begin
                    ledtmp[17] <= 1'b0;
                    for (int i=16; i>-1; i--)
                        ledtmp[i] <= ledtmp[i+1];
                end
            end
        endcase
    end


    always@(posedge clk or negedge reset_n)
    if(!reset_n) begin
            sig <= aller;
            finishl <= 0;
            finishr <= 1;        
    end 
    else
        begin
            if(ledtmp[0]) begin
                finishr <= 1'b1;
                finishl <= 1'b0;
            end               
            else if(ledtmp[17]) begin 
                finishl <= 1'b1;
                finishr <= 1'b0;
            end
            else 
                begin
                finishl <= 1'b0;
                finishr <= 1'b0;
                end

            if(ledtmp[2] && sig==retour)
                sig <= aller;
            if(ledtmp[15] && sig==aller)
                sig <= retour;
        end
    
endmodule

