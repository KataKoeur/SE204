module MEDIAN #(parameter SIZE = 8)(
        input logic [SIZE-1:0]DI,
        input logic DSI,
        input logic nRST,
        input logic CLK,
        output logic [SIZE-1:0]DO,
        output logic DSO
        );

logic BYP;
logic [5:0]cpt;

//Module MED
MED I_MED(.DI(DI), .DSI(DSI), .BYP(BYP), .CLK(CLK), .DO(DO));

//Gestion de la sortie DSO
always@(*)
DSO = (cpt>40);

//Le compteur s'incrémente à chaque coup d'horloge
//et permet de faire avancer l'automate
//Le reste (actif à 0) remet le compteur à 0
always@(posedge CLK)
if(!nRST)
        begin
        cpt <= 0;
        DSO <= 0;
        BYP <= 0;
        end
else
        begin
        if(DSI) //Lecture des pixels en entrée
                begin
                cpt <= 0;
                DSO <= 0;
                end
        else    //Tous les pixels sont présent, Lancement de l'algo
                begin
                cpt <= cpt + 1;
                end
        end

//Machine à état
always@(*)
if(DSI)	BYP <= 1;
else
	case (cpt)
		6'd0   : BYP = 0;
		6'd9   : BYP = 1;
		6'd10  : BYP = 0;
		6'd17  : BYP = 1;
		6'd19  : BYP = 0;
		6'd25  : BYP = 1;
		6'd28  : BYP = 0;
		6'd33  : BYP = 1;
		6'd37  : BYP = 0;
	endcase

endmodule
