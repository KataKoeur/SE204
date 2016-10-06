module MED #(parameter SIZE = 8, NB_PIXEL = 9)(
        input logic [SIZE-1:0]DI,
        input logic DSI,
        input logic BYP,
        input logic CLK,
        output logic [SIZE-1:0]DO
        );

integer i;
logic [SIZE-1:0] registre [0:NB_PIXEL-1];
logic [SIZE-1:0] MAX, MIN;

//Module MCE
MCE #(.SIZE(SIZE)) I_MCE(.A(registre[NB_PIXEL-1]), .B(registre[NB_PIXEL-2]), .MAX(MAX), .MIN(MIN));

//registre à décalage de R0 à R7
always@(posedge CLK)
for (i=0;i<=NB_PIXEL-3;i=i+1)
begin
	registre[i+1] <= registre[i];
end

//Gestion de l'entrée BYP
always@(posedge CLK)
if (BYP) registre[NB_PIXEL-1] <= registre[NB_PIXEL-2];
else 	 registre[NB_PIXEL-1] <= MAX;

//Gestion de l'entrée DSI
always@(posedge CLK)
registre[0] <= (DSI)? DI: MIN;

//Gestion de la sortie DO
always@(*)
DO <= registre[NB_PIXEL-1];

endmodule
