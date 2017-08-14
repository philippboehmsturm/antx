function lblist=getlist
lblist={};
lblist(end+1,:)={'shortcuts' 's'   ''       'show shortcuts'};
lblist(end+1,:)={'vol show' 'v'   ''       'toggle show/hide volumes'};
lblist(end+1,:)={'vol transp' 'v'   'control'       'toggle volume transparency'};
lblist(end+1,:)={'brain show' 'b'   ''       'toggle show/hide brain'};

lblist(end+1,:)={'light toggle'  'i' 'control' 'toggle LIGHT light-dark'};
lblist(end+1,:)={'light rand' 'i' '' 'change light sources randomly light source'};
lblist(end+1,:)={'axis' 'a' '' 'toggle axes size small/large'};
lblist(end+1,:)={'ring show' 'r' '' 'toggle show/hide ring'};
lblist(end+1,:)={'textlabel all' 't' 'control' 'toggle show/hide all textlabels'};
lblist(end+1,:)={'textlabel brain' 't' '' 'toggle show/hide textlabels close to brain'};
lblist(end+1,:)={'lines all' 'l' 'control' 'toggle show/hide all lines'};
lblist(end+1,:)={'lines' 'l' '' 'toggle show/hide lines close to brain'};
lblist(end+1,:)={'view userdef' 'f1' '' 'show userdefined view (needs to be defined first -->[f12])'};
lblist(end+1,:)={'view top' 'f2' '' 'top view'};
lblist(end+1,:)={'view left' 'f3' '' 'left view'};
lblist(end+1,:)={'view right' 'f4' '' 'right view'};
lblist(end+1,:)={'view front' 'f5' '' 'front view'};
lblist(end+1,:)={'view back' 'f6' '' 'back view'};
lblist(end+1,:)={'view def. userdef' 'f12' '' 'save view as userdefined view'};

lblist(end+1,:)={'explode view' 'e' '' 'toggle show/hide circle with volumes'};
lblist(end+1,:)={'ring show' 'r' '' 'toggle show/hide ring'};
lblist(end+1,:)={'material' 'm' '' 'change material [def,metal,dull,shiny]'};
lblist(end+1,:)={'brain' 'b' '' 'toggle show/hide brain'};
lblist(end+1,:)={'xslice->' 'x' '' 'slicing x direction-->right'};
lblist(end+1,:)={'yslice->' 'y' '' 'slicing y direction-->front'};
lblist(end+1,:)={'zslice->' 'z' '' 'slicing z direction-->top'};
lblist(end+1,:)={'xslice-<' 'x' '' 'slicing x direction-->left'};
lblist(end+1,:)={'yslice-<' 'y' '' 'slicing y direction-->back'};
lblist(end+1,:)={'zslice-<' 'z' '' 'slicing z direction-->bottom'};
lblist(end+1,:)={'xslice hide' 'x' 'alt' 'hide xslice'};
lblist(end+1,:)={'yslice hide' 'y' 'alt' 'hide yslice'};
lblist(end+1,:)={'zslice hide' 'z' 'alt' 'hide zslice'};
lblist(end+1,:)={'proj2surf' 'p' '' 'project activation to surface'};
lblist(end+1,:)={'proj2surf cmap' 'p' 'shift' 'change colormap & project activation to surface'};