// Un fifo synchrone
// Le port d'entrée se comporte comme un esclave, et signale la réussite de l'écriture par un acquitement.
// Le port de sortie se comporte comme un maître et signale la présence d'une donnée par une requète.
// L'acquitement en écriture est combinatoire.
// La requète en sortie est synchrone.
// Le maître doit maintenir la requère en entrée tant que l'acquitement n'est pas arrivé.

module fifo_sm #( parameter DATA_WIDTH  = 8, DEPTH_WIDTH = 5)
                  ( input logic clk, 
                    input logic rst, 
                    // Port d'entrée
                    input logic wreq,
                    input logic [DATA_WIDTH-1:0] wdata,
                    output logic wack,
                    // Port de sortie
                    output logic rready,
                    output logic [DATA_WIDTH-1:0] rdata,
                    input  logic rack); 

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
//(* altera_attribute = "-name  add_pass_through_logic_to_inferred_rams off"*)
logic [DATA_WIDTH-1:0]     mem [DEPTH-1:0];

// Les compteurs d'écriture et de lecture
// ATTENTION nous utilisons un bit de plus que nécessaire
// pour faciliter la détection des dépassement
typedef struct packed {
              logic segment ;
              logic [DEPTH_WIDTH-1:0] address ;  
              } index_t ;


// Le code de la mémoire double port
// L'écriture ne se fait que toutes les conditions
// sont réunie (requète et fifo non pleine)
// La lecture est systèmatiquement anticipée 
// dans l'attente d'un acquittement futur.
index_t  r_index,w_index;
always_ff @(posedge clk)
begin
  if (wack)
      mem[w_index.address] <= wdata;
end
assign  rdata = mem[r_index.address];

// Drapeaux internes à la FIFO
logic wfull,rempty ;

// Réponses aux requêtes en écriture
assign wack  = wreq & ~wfull ; 

// Création de requêtes en lecture
assign rready =  ~rempty ;

// calcul des compteurs de lecture et d'écriture
// logique de détection de dépassement 
always_ff @(posedge clk )
begin:indexes
    // Variables combinatoires internes
    index_t  next_r_index,next_w_index;
    logic next_empty_or_full, next_empty, next_full ,next_same_segment;

    // Calcul combinatoire des valeurs pour le cycle suivant
    next_r_index = r_index + rack ;
    next_w_index = w_index + wack;
    next_empty_or_full = (next_r_index.address == next_w_index.address) ;
    next_same_segment  = (next_r_index.segment == next_w_index.segment) ;
    next_empty         = ( next_empty_or_full & next_same_segment );
    next_full          = ( next_empty_or_full & ~next_same_segment );

    // Sauvegarde dans les registres
    r_index <= next_r_index  ;
    w_index <= next_w_index  ;
    rempty <= next_empty ;
    wfull <= next_full ;
    if (rst)
    begin
        r_index    <= '0;
        w_index    <= '0;
        rempty  <= 1 ;
        wfull   <= 0 ;
    end
end
endmodule
