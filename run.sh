#!/bin/sh

if [ -z "$1" ]; then
    echo "Erro: É preciso especificar o número do teste"
    exit 1
fi

iverilog -o tb *.v
rm -f saida.out
cp test/teste$1.txt teste.txt
./tb > saida.out
cp saida.out test/saida$1.out
cp saida.vcd test/saida$1.vcd
rm -rf saida.out saida.vcd

# Substituição de processo removida para compatibilidade com sh
grep '===' test/saida$1.out > temp_filtrado.out

if diff -Z temp_filtrado.out test/saida$1.ok >/dev/null; then
    echo "OK"
    result=0
else
    echo "ERRO"
    result=1
fi

rm -f temp_filtrado.out
exit $result
