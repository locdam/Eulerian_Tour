function [eidx] = nextEdge(G, S)
    %First, sort S from small to big
sort_S = sort(S);

%run a loop across the lenght of S
    for i=1:length(sort_S)
        
       if isinf(G.Edges.dfN(sort_S(i)))
           eidx = sort_S(i)
       break
       end
    end
       
end