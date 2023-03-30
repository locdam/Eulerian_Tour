function [eidx, new_id] = nextEdge(G, S, pre_id)    %First, sort S from small to big
sort_S = sort(S);

%run a loop across the lenght of S
    for i=1:length(sort_S)
        
       if isinf(G.Edges.dfN(sort_S(i)))
           eidx = sort_S(i);
           endpts = G.Edges.EndNodes(eidx,:);
            endpts = findnode(G,{endpts{1} endpts{2}});
    
            if endpts(1) == pre_id
        new_id = endpts(2);
    elseif endpts(2) == pre_id
        new_id = endpts(1);
    end

       break
       end
    end
       
end