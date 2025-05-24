module Contador (
    input  wire clk,           // Clock
    input  wire rst_n,         // Reset assíncrono, ativo em nível baixo
    input  wire acrescer,      // Sinal de incremento
    input  wire decrescer,     // Sinal de decremento
    output reg [7:0] saida     // Saída de 8 bits
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset ativo em nível baixo: inicializa com 106
            saida <= 8'd106;
        end else begin
            // Se apenas acrescer estiver ativo
            if (acrescer && !decrescer)
                saida <= saida + 1;
            // Se apenas decrescer estiver ativo
            else if (decrescer && !acrescer)
                saida <= saida - 1;
            // Se ambos forem 0 ou ambos 1: não faz nada
        end
    end

endmodule
