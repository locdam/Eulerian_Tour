function [S, new_id] = FrontierEdge(G, S, pre_id, eidx)
    S = [];
    S_new = outedges(G, pre_id);
    for i = 1:length(S_new)
        if isinf(G.Edges.dfN(S_new(i)))
            S(end+1) = [S_new(i)];
        end
    end
    endpts = G.Edges.EndNodes(eidx,:);
    endpts = findnode(G,{endpts{1} endpts{2}});
    
    if endpts(1) == pre_id
        new_id = endpts(1);
    elseif endpts(2) == pre_id
        new_id = endpts(2);
    end
    
    if isempty(S)
        for i = 1: numnodes(G)
            e = outedges(G, i);
            if ismember(-Inf, G.Edges.dfN(e))     
                S_new = e;
                for k = 1:length(S_new)
        if isinf(G.Edges.dfN(S_new(k)))
            S(end+1) = [S_new(k)];
        end
    end
    
            break
            end
    endpts = G.Edges.EndNodes(eidx,:);
    endpts = findnode(G,{endpts{1} endpts{2}});
    
    if endpts(1) == pre_id
        new_id = endpts(1);
    elseif endpts(2) == pre_id
        new_id = endpts(2);
    end        
end