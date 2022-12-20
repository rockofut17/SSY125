function AMPM(data_in)
kmod=1/sqrt(10);
const=[(1-1i),(-3+3i),(1+3i),(-3-1i),(3-3i),(-1+1i),(3+1i),(-1-3i)]*kmod;
bit_trio = int2str(reshape(data_in,3,numel(data_in)/3)');
constVal = const(bin2dec(bit_trio)+1);
scatterplot(constVal);
end