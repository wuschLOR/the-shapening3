function [xmm, ymm] = monitorspec (override=true)

# output size of 1 px in mm

  # erst mal das spec file laden
  #http://rosettacode.org/wiki/Check_that_file_exists#MATLAB_.2F_Octave
  if exist('monitorspec.csv','file') == 2
    rawCell = csv2cell( 'monitorspec.csv' , ',');

    specHead = rawCell(1     , :); #  zerlegten der Correct in den specHead
    specBody = rawCell(2:end , :); #  und dem inhaltlichen specBody

    specs = cell2struct (specBody , specHead , 2);
  else
    # create struct 
    specs = struct( macaddress, [] , model, [])
    specs(1).macaddress = NA
    specs(1).model      = NA
    specs(1).xmm        = NA
    specs(1).ymm        = NA
#     specs(1).xpx        = NA
#     specs(1).ypx        = NA
  endif
  
  #sysinfo holen
  sysinfo=Screen('Computer');
  
  # erst mal schaun ob n Eintrag da ist
  entry=false
  for i = 1:length(specs)
    if trcmp (specs(i).macaddress , sysinfo.MACAddress)
      entry=true
      rightentry=i
    endif
  endfor
  
  # wenn eintrag nicht da dann neuen schreiben
  if entry==false
  
    rightentry=length(specs)+1 # neuer eintrag
    specs(rightentry).macaddress = sysinfo.MACAddress
#     disp (sysinfo.MACAddress)
    specs(rightentry).model      = input ('Screen name: ' , 's')
    specs(rightentry).xmm        = input ('Screen size lenght in mm aka x: ')
    specs(rightentry).ymm        = input ('Screen size height in mm aka y: ')
#     specs(rightentry).xpx        = moninfo.
#     specs(rightentry).ypx        = moninfo.
    
    #neue zeile im cell erstellen
    newCellline =                { ...
    specs(rightentry).macaddress , ...
    specs(rightentry).model      , ...
    specs(rightentry).xmm        , ...
    specs(rightentry).ymm        , ...
                                 }
    #speichern
    specCELL = [rawCell ; newCellline ];
    cell2csv('monitorspec.csv' , specCELL , ',' )
  endif
  
  # output
  xmm= specs(rightentry).xmm
  ymm= specs(rightentry).ymm

endfunction