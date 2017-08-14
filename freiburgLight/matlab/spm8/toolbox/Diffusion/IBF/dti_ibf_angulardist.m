for k=1:length(X(:))
for l=k+1:length(X(:))
c(k,l)=X(k)-X(l);
c(l,k)=c(k,l);
end
end
