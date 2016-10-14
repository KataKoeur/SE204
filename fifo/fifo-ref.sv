// Une fifo synchrone
// Tous les signaux de sortie sont séquentiels.
// Les ports d'entrée et de sortie se comportent comme des "esclaves"
// Sur requete d'écriture une donnée est poussée dans la FIFO.
// Sur requete de lecture une donnée sort de la FIFO au cycle suivant (lecture synchrone)
// La FIFO génère des indicateurs "wfull" et "rempty"
// La FIFO ne vérifie pas les incohérences (écriture lorsque la FIFO et pleine, lecture lorsque la FIFO est vide)

module fifo_ref #( parameter DATA_WIDTH  = 8, DEPTH_WIDTH = 5)
                  ( input logic clk, 
                    input logic rst, 
                    // Port d'entrée
                    input logic wreq,  
                    input logic [DATA_WIDTH-1:0] wdata, 
                    output logic wfull, 
                    // Port de sortie
                    input logic rreq, 
                    output logic [DATA_WIDTH-1:0] rdata, 
                    output logic rempty);

// Nombre de données de la FIFO
localparam DEPTH = 2**DEPTH_WIDTH;

// La mémoire  de la FIFO
// Attention les mémoires double port inférées ont un comportement non
// prévisible lorsqu'il y a une lecture et une écriture à la même adresse.
// Les outils de synthèse ne savent pas détecter si ce cas peut arriver ou 
// non. Ils peuvent ajouter une logique de "bypass" inutile autour de la mémoire
// Attention, par construction nous garantissons que la lecture et l'ecriture ne 
// sont pas à la même adresse. Nous utilisons des attributs spécifiques aux outils
// pour guider la synthèse
// The 2 attributes are equivalent; the first targets Precision RTL synthesis
// and the second QuartusII
(* synthesis, ignore_ram_rw_collision =  "true" *)
(* altera_attribute = "-name  add_pass_through_logic_to_inferred_rams off"*)
logic [DATA_WIDTH-1:0]     mem [DEPTH-1:0];

// Les compteurs d'écriture et de lecture
// ATTENTION nous utilisons un bit de plus que nécessaire
// pour faciliter la détection des dépassement
typedef struct packed {
              logic segment ;
              logic [DEPTH_WIDTH-1:0] address ;  
              } index_t ;


// Le code de la mémoire double port
// La lecture ou l'écriture ne se fait 
// que sur requète extern
index_t  r_index,w_index;
always_ff @(posedge clk)
begin
  if (wreq)
      mem[w_index.address] <= wdata;
  if (rreq)
      rdata <= mem[r_index.address];
end


// calcul des compteurs de lecture et d'écriture
// logique de détection de dépassement 
always_ff @(posedge clk )
begin:indexes
     // Variables combinatoires internes
    index_t  next_r_index,next_w_index;
    logic next_empty_or_full, next_empty, next_full ,next_same_segment;

    // Calcul combinatoire des valeurs pour le cycle suivant
    next_r_index = (r_index + rreq) ;
    next_w_index = (w_index + wreq) ;
    next_empty_or_full = (next_r_index.address == next_w_index.address) ;
    next_same_segment = (next_r_index.segment == next_w_index.segment) ;
    next_empty = ( next_empty_or_full &  next_same_segment );
    next_full  = ( next_empty_or_full & ~next_same_segment );

    // Sauvegarde dans les registres
    r_index <= next_r_index;
    w_index <= next_w_index;
    rempty <=  next_empty ;
    wfull  <=  next_full  ; 
    if (rst)
    begin
        r_index    <= '0;
        w_index    <= '0;
        rempty      <= 1;
        wfull       <= 0;
    end
end
endmodule
