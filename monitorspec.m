function [xmm , ymm] = monitorspec (override=true)

  # erst mal das spec file laden
  #http://rosettacode.org/wiki/Check_that_file_exists#MATLAB_.2F_Octave
  if exist('monitorspec.csv','file') == 2
    rawCell = csv2cell( 'monitorspec.csv' , ',');

    specHead = rawCell(1     , :); #  zerlegten der Correct in den specHead
    specBody = rawCell(2:end , :); #  und dem inhaltlichen specBody

    specs = cell2struct (specBody , specHead , 2);
  else
    # create csv 
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
    rightentry=length(specs)+1
    specs(length(specs)+1).macaddress = sysinfo.MACAddress
    specs(length(specs)+1).model      = moninfo.
    specs(length(specs)+1).xmm        = moninfo.
    specs(length(specs)+1).ymm        = moninfo.
    
    #speichern
    cell2csv('monitorspec.csv' , specs , ',' )
  endif
  
  # output
  xmm= specs(rightentry).xmm
  ymm= specs(rightentry).ymm

endfunction