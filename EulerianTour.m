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

currentDf = 0;

% G.Edges.dfN(v_id) = currentDf;
[S,nV] = outedges(G,v_id);

S = S(nV~=v_id);

T = [];

pre_id = v_id;
while numedges(G) >= length(T)
      currentDf = currentDf+1;
      [eidx, new_id] = nextEdge(G, S, pre_id);
      T(end+1) = [eidx];
      
%       endpts = G.Edges.EndNodes(eidx,:);
%       endpts = findnode(G,{endpts{1} endpts{2}});
%       
%       if endpts(1) == new_id
%           pre_id = endpts(2);
%       elseif endpts(2) == new_id
%           pre_id = endpts(1);
%       end
      G.Edges.dfN(eidx) = currentDf;
      [S, pre_id] = FrontierEdge(G, S, new_id, eidx)
%       pre_id = new_id;
end

end