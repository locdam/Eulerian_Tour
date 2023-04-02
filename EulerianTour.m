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

origID = (1:numedges(G));
G.Edges.origId = origID';

T = graph;
% T = addnode(T,1);

% T.Nodes.origId(1) = v_id;
% T.Nodes.Name(1) = G.Nodes.Name(v_id);

currentDf = 0;

% G.Edges.dfN(v_id) = currentDf;
[S,nV] = outedges(G,v_id);

S = S(nV~=v_id);
%T =[];
pre_id = v_id;

T = addnode(T, G.Nodes);
while ~isempty(S)
      currentDf = currentDf+1;
      [eidx, w_id] = nextEdge(G, S, pre_id);
     G.Edges.dfN(eidx) = currentDf; 
%       if ~ismember(w_id, T.Nodes.origId)
%         newNode = table(G.Nodes.Name(w_id), w_id,'VariableNames', {'Name','origId'});
%         T = addnode(T,newNode);
%       end
%     
    % create the edge and its attributes (endpts and original id in G) to be added in T
newEdge = table([pre_id,w_id],G.Edges.Name(eidx),G.Edges.dfN(eidx),eidx,'VariableNames', {'EndNodes','Name','dfN','origId'});
    T = addedge(T,newEdge);
    %T = addedge(T,G.Edges(eidx,:));

      [S, pre_id] = FrontierEdge(G, S, w_id, eidx);
%       pre_id = new_id;
end

a = T.Edges.origId;
b = T.Edges.dfN;
[~,bsort]=sort(b); 
    
    H=a(bsort);
    H = H';
%     T = addnode(T, G.Nodes);
while ~isempty(v_id)        
        for i = 1: numnodes(G)
            e = outedges(G, i);
            if ismember(-Inf, G.Edges.dfN(e))
                v_id = i;
                P = [];
            else
                v_id = [];
            end
            while ismember(-Inf, G.Edges.dfN(e))
%             if ismember(-Inf, G.Edges.dfN(e))
                es = outedges(T, v_id);
                %find closed cycle starting from nodes i
                [A, G] = Trail(G, v_id);
%                 if ~ismember(i, T.Nodes.origId)
%                     newNode = table(G.Nodes.Name(i), i,'VariableNames', {'Name','origId'});
%                     T = addnode(T,newNode);
%                 end
%                 newEdge = table([pre_id,w_id],G.Edges.Name(eidx),eidx,G.Edges.dfN(eidx),'VariableNames', {'EndNodes','Name','origId','dfN'});
                P = cat(2,P,A);
%                 es = outedges(T, i);
                %G.Edges.origId(A);
                es_origId = T.Edges.origId(es);
                if es_origId(1) == es_origId(2)
                    pos = find(H == es_origId(1));
                    pos1 = pos(1);
                    pos2 = pos(2);
                    H = [H(1:pos1), T.Edges.origId(P)', H(pos2:end)];

                elseif es_origId(1) ~= es_origId(2)
                    pos1 = find(H == es_origId(1));
                    pos2 = find(H == es_origId(2));
                
                    if pos1 < pos2 
                        H = [H(1:pos1), P, H(pos2:end)];
                    elseif pos1 > pos2
                        H = [H(1:pos2), P, H(pos1:end)];
                    end
                end
                T = addedge(T, G.Edges(A,:));
%             end
            end
        end
    
end
%      end
    T = H';
end % end function EulerianTour

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