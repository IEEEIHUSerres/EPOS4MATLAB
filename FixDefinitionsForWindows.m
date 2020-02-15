function FixDefinitionsForWindows = FixDefinitionsForWindows(file)
definitions = fileread(file);

STRING_TO_MATCH='extern "C" ';

definitionsFixed = strrep(definitions, STRING_TO_MATCH,'');
delete(file);

fileID = fopen(file,'w');
fprintf(fileID, definitionsFixed);
fclose(fileID);
end