function hdr = dicom_convert_to_printable(hdr)
% DICOM_CONVERT_TO_PRINTABLE convert non-decoded private fields into char()

for ch = 1:numel(hdr)
    fn   = fieldnames(hdr{ch});
    psel = ~cellfun(@isempty,regexp(fn,'^Private_'));
    fn   = fn(psel);
    for cf = 1:numel(fn)
        if isnumeric(hdr{ch}.(fn{cf}))
            try
                hdr{ch}.(fn{cf}) = char(hdr{ch}.(fn{cf}));
            end
        end
    end
end