function [T] = Trail(G, v_id)
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
 %v_id = 1;
G.Edges.dfN = -inf(numedges(G),1);

currentDf = 0;

% G.Edges.dfN(v_id) = currentDf;
[S,nV] = outedges(G,v_id);

S = S(nV~=v_id);

T = [];

for i = 1:numnodes(G)
    if rem(degree(G, i),2) ~= 0
        msg = 'The output is wrong.';
        error(msg);
    end
end
pre_id = v_id;
while ~isempty(S)
      currentDf = currentDf+1;
      [eidx, new_id] = nextEdge(G, S, pre_id);
      T(end+1) = [eidx];
      
      
        
      G.Edges.dfN(eidx) = currentDf;
      [S, pre_id] = FrontierEdge(G, S, new_id, eidx);
%       pre_id = new_id;
end


T

T = T';
end