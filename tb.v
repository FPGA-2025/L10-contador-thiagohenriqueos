`timescale 1ns/1ps

module tb();

    reg clk = 0;
    reg rst_n = 0;
    reg acrescer = 0;
    reg decrescer = 0;
    wire [7:0] saida;

    // Instancia o DUT
    Contador dut (
        .clk(clk),
        .rst_n(rst_n),
        .acrescer(acrescer),
        .decrescer(decrescer),
        .saida(saida)
    );

    // Clock
    always #5 clk = ~clk;

    // Memória de testes
    reg [9:0] memoria [0:255]; // xx_xxxxxxxx = 10 bits
    integer i, num_linhas;

    initial begin
        // Lê o arquivo (modifique o nome do arquivo conforme necessário)
        $readmemb("teste.txt", memoria);
        $dumpfile("saida.vcd"); // gera um arquivo .vcd para visualização no gtkwave
        $dumpvars(0, tb); // salva as variáveis do módulo tb

        // Reset inicial
        rst_n = 0;
        #12;
        rst_n = 1;

        // Processamento das linhas do arquivo
        for (i = 0; i < 256; i = i + 1) begin
            // Verifica se ainda há instruções válidas (pode parar ao encontrar valor indefinido)
            if (^memoria[i] === 1'bx) begin
                $display("Fim da memória em linha %0d", i);
                $finish;
            end

            // Extrai sinais da linha
            {acrescer, decrescer} = memoria[i][9:8];
            #10; // Espera 1 ciclo de clock
            if (saida !== memoria[i][7:0]) begin
                $display("Erro na linha %0d: acrescer=%b, decrecer=%b, esperado=%d, obtido=%d",
                          i, acrescer, decrescer, memoria[i][7:0], saida);
            end else begin
                $display("=== OK na linha %0d: acrescer=%b, decrecer=%b, saida=%d",
                          i, acrescer, decrescer, saida);
            end
        end

        $finish;
    end

endmodule
