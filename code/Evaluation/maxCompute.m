function cost=maxCompute(mat)

if size(mat,1) ==1
    cost = sum(mat);
else 
cost = sum(max(mat));

end