function [T] = EulerianTour(G)
 
% check if vertices have names
if (~sum(ismember(G.Nodes.Properties.VariableNames,'Name')))
    % if not, give names using its indices
    Vnames = int2str(1:numnodes(G));
    G.Nodes.Name = split(Vnames);
end

% check if edges have names
if (~sum(ismember(G.Edges.Properties.VariableNames,'Name')))
    % if not, give names using its indices
    Enames = int2str(1:numedges(G));
    G.Edges.Name = split(Enames);
end
 v_id = 1;
G.Edges.dfN = -inf(numedges(G),1);
G.Nodes.dfN = -inf(numnodes(G),1);

T = graph;
T = addnode(T,1);

T.Nodes.origId(1) = v_id;
T.Nodes.Name(1) = G.Nodes.Name(v_id);

currentDf = 0;

% G.Edges.dfN(v_id) = currentDf;
[S,nV] = outedges(G,v_id);

S = S(nV~=v_id);
%T =[];
pre_id = v_id;
while ~isempty(S)
      currentDf = currentDf+1;
      [eidx, w_id] = nextEdge(G, S, pre_id);
     G.Edges.dfN(eidx) = currentDf; 
      if ~ismember(w_id, T.Nodes.origId)
        newNode = table(G.Nodes.Name(w_id), w_id,'VariableNames', {'Name','origId'});
        T = addnode(T,newNode);
      end
    
    % create the edge and its attributes (endpts and original id in G) to be added in T
    newEdge = table([pre_id,w_id],G.Edges.Name(eidx),eidx,G.Edges.dfN(eidx),'VariableNames', {'EndNodes','Name','origId','dfN'});
    T = addedge(T,newEdge);

      [S, pre_id] = FrontierEdge(G, S, w_id, eidx);
%       pre_id = new_id;
end

a = T.Edges.origId;
b = T.Edges.dfN;
[~,bsort]=sort(b); 
    
    H=a(bsort);
    H = H';
        
        for i = 1: numnodes(G)
            e = outedges(G, i);
            if ismember(-Inf, G.Edges.dfN(e))     
                [A, G] = Trail(G, i);
                es = outedges(T, i);
                es_origId = T.Edges.origId(es);
                pos1 = find(H == es_origId(1));
                pos2 = find(H == es_origId(2));
                if pos1 < pos2 
                    H = [H(1:pos1), A, H(pos2:end)];
                elseif pos1 > pos2
                    H = [H(1:pos2), A, H(pos1:end)];
                end
            end
        end
%      end
    T = H';

end % end function EulerianTour
