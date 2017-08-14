function tbxvol_export_surf(srf)
% export surfaces to blender format
% can handle either patch structures or patch graphics objects
% in the latter case, colouring will be approximately translated
% (blender does not seem to allow for vertex colouring, so colours need
% to be interpolated per face)

for cs=1:numel(srf)
  switch surftype(srf{cs}),
   case 'handle',
    vertices = get(srf{cs}, 'Vertices')';
    faces = get(srf{cs}, 'Faces')'-1;
    facecol = squeeze(get(srf{cs}, 'CData'));
    if ndims(facecol)==3
      % we have vertex colours and need to compute face colours
      warning(['Vertex colouring not supported, using mean colour value ' ...
               'per surface']);
      facecol = squeeze(mean(facecol));
    end;
    facesstr=sprintf('%d%s\\t0x%%02x%%02x%%02x\\n', ...
                     size(faces,1), repmat('\t%d', 1,size(faces,1)));
    faces = [faces; round(facecol'*255)];
    faces = faces(:,all(isfinite(faces)));
   case 'struct',
    vertices=srf{cs}.vertices';
    faces=srf{cs}.faces'-1;
    facecol = [128 128 128];
    facesstr=sprintf('%d%s\\t0x%02x%02x%02x\\n', ...
                     size(faces,1), repmat('\t%d', 1,size(faces,1)), ...
                     facecol); 
  end;
  fid=fopen(sprintf('surf-%d.obj',cs),'w');
  fprintf(fid,'3DG1\n%d\n',size(vertices,2));
  fprintf(fid,'%.3f\t%.3f\t%.3f\n',vertices);
  fprintf(fid,facesstr,faces);
  fclose(fid);
end;

return;

function t=surftype(srf)

if isstruct(srf)
  if isfield(srf,'vertices') && isfield(srf,'faces')
    t='struct';
    return;
  end;
elseif ishandle(srf) && strcmp(get(srf,'type'),'patch')
  t='handle';
  return;
else
  error('Don''t know how to handle this surface');
end;