% Script para procesar archivos del espectrómetro
% Toma el listado de los archivos y calcula el promedio de los datos
% La salida la guarda en el archivo de texto prom.dat en el directorio de
% los datos
%
clear all   % Borra las variables
clc         % Borra pantalla
[FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.txt','Seleccione los archivos','MultiSelect', 'on');
CANT=length(FILENAME);
LAMBDA=zeros(288,1);
SIGNAL=zeros(288,1);
for i=1:CANT
    fid=fopen(char(strcat(PATHNAME,FILENAME(:,i))),'r');
    % Lee cada linea
    tline = fgetl(fid);     % Lee la primera línea y la descarta
    CNT=0;
    while 1
        tline = fgetl(fid);
        CNT=CNT+1;
        if ~ischar(tline), break, end
        if i==1
            LAMBDA(CNT)=str2double(tline(1:8));
        end
        SIGNAL(CNT)=SIGNAL(CNT)+str2double(tline(9:length(tline)));
    end
    fclose(fid);
end
SIGNAL=(SIGNAL-100*CANT)/CANT;
plot(LAMBDA,SIGNAL,'o')
xlabel('\lambda');
ylabel('Cuentas promedio');

[filename, pathname] = uiputfile('*.dat', 'Grabar los datos');
fid=fopen(char(strcat(pathname,filename)),'w+');
for i=1:length(LAMBDA)
    fprintf(fid,'%3.2f     %3.2f\n',LAMBDA(i),SIGNAL(i));
end
fclose(fid);