function [A, G] = Trail(G, v_id)
currentDf = max(G.Edges.dfN);
pre_id = v_id;
S = outedges(G, v_id);
A = [];
    currentDf = currentDf+1;
    [eidx, w_id] = nextEdge(G, S, pre_id);
    A(end+1) = [eidx];

    G.Edges.dfN(eidx) = currentDf; 
    [S, pre_id] = FrontierEdge(G, S, w_id, eidx);

while pre_id ~= v_id
    currentDf = currentDf+1;
    [eidx, w_id] = nextEdge(G, S, pre_id);
    A(end+1) = [eidx];

    G.Edges.dfN(eidx) = currentDf; 
    [S, pre_id] = FrontierEdge(G, S, w_id, eidx);
end

end