function [table idxLUT] = buildtable(tree)
table = recur(tree);
cnt = 1;
for k = 1:length(table)       
    for j = 1:length(table{k})
        str = table{k}(j).allinfo;
        str.includes = [table{k}(1:j-1).id];
        str.children = [table{k}(j).children];
        str.nameinlist = [repmat('-',[1 j]) str.name];
        idxLUT(cnt) = str;
        
        cnt = cnt + 1;
    end
end
[dummy ids] = unique([idxLUT.id],'first');
ids = sort(ids,'ascend');
idxLUT = idxLUT(ids);

function list = recur(tree)

list = [];
children = [];
for k=1:length(tree.children) 
    clist = recur(tree.children{k});
    children = [children ; cellfun(@(x) x(end).id,clist)];
    list = [list ; clist];
end

item.id = tree.id;
item.acro = tree.acronym;
item.atlas_id =tree.atlas_id;
item.children = children;
item.allinfo = rmfield(tree,'children');
if isfield(tree,'name')
    item.name = tree.name;
else
    item.name = '<>';
end
if not(isempty(list))
    for k=1:length(list)
        list{k} = [item list{k}];
    end
else
    list = {item};
end



