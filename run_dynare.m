



% matlab
set(0, 'DefaultFigureVisible', 'on');
set(groot,'DefaultFigureWindowStyle','docked') ;
clc;
close all;




switch USER
    case 'Filip'
        FOLDER.work = '~/Dropbox/policy/bank_model/dynare_testing/';
    case 'Rasmus'
        error('running folder not defined')
    case 'Emil'
        error('running folder not defined')        
    case 'Jens'
        error('running folder not defined')        
end

FOLDER.base = cd; 

cd(FOLDER.work); % move to the work directory

% copy files
source = [FOLDER.base,'/',DATA];
destination = [FOLDER.work,'/',DATA];
copyfile(source,destination);

source = [FOLDER.base,'/',MODEL];
destination = [FOLDER.work,'/',MODEL];
copyfile(source,destination);


eval(['dynare ',MODEL]); % run dynare

cd(FOLDER.base); % move back

