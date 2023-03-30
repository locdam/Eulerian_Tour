function [S, pre_id] = FrontierEdge(G, S, new_id, eidx)
    S = [];
    S_new = outedges(G, new_id);
    for i = 1:length(S_new)
        if isinf(G.Edges.dfN(S_new(i)))
            S(end+1) = [S_new(i)];
        end
    end
    endpts = G.Edges.EndNodes(eidx,:);
    endpts = findnode(G,{endpts{1} endpts{2}});
    
    if endpts(1) == new_id
        pre_id = endpts(1);
    elseif endpts(2) == new_id
        pre_id = endpts(2);
    end     
    
%     if isempty(S)
%         for i = 1: numnodes(G)
%             e = outedges(G, i);
%             if ismember(-Inf, G.Edges.dfN(e))     
%                 S_new = e;
%                 for k = 1:length(S_new)
%                     if isinf(G.Edges.dfN(S_new(k)))
%                         S(end+1) = [S_new(k)];
%                     end
%                 end
%                 pre_id = i;
%                 break
%             end
%         end
%     end
       
end