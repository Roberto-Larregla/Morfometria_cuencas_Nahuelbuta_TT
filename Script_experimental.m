%%
% Para borrar todas las variables del espacio de trabajo actual utilizamos la función "clear"%
clear
% Agregamos a la ruta de busqueda de Matlab la carpeta de la libreria 
% TopoToolbox utilizando la función "addpath", ademas al utilizar addpath
% en conjunto de genpath estaremos agregando las subcarpetas de esta
addpath(genpath('C:\Users\rober\Desktop\Morfometria  de cuencas en Nahuelbuta\topotoolbox-master'));
% Con esto habremos preparado Matlab para comenzar a utilizar TopoToolbox%
%%
% Empezaremos cargando un modelo de elevación en nuestro espacio 
% de trabajo utilizando la función GRIDob y lo asignaremos a la variable
% DEM
DEM = GRIDobj();
%%
% Calculamos la dirección de flujo del DEM creando un FLOWobj y asignandolo
% a la variable FD, ademas utilizaremos la opción de preprocesado "carve" para corregir las
% imperfecciones del DEM
FD  = FLOWobj(DEM,'preprocess','carve');
%Luego calcularemos la acumulación de flujo a partir de las direcciones de
%flujo utilizando la función flowacc y asignandola a la variable FA
FA  = flowacc(FD);
%Por ultimo vamos a delinear la red hídrica creando un STREAMobj, para esto
%consideraremos un area minima de 2.000.000 m2 para cada drenaje
S = STREAMobj(FD,'minarea',2e5,'unit','map');
% Seleccionareremos la red de cauces conectados de mayor tamaño y la
% asignaremos a la variable Sm
Sm = klargestconncomps(S);
% Y vamos a definir el cauce troncal de la red hídrica Sm como
% la variable St
St = trunk(Sm);
%%
% Ahora que tenemos nuestra red hídrica lista crearemos un perfil longitudinal del trunk 
% river, para esto debemos escoger un valor para el factor de suavizado "K"
K = 6;
% Esta vez utilizaremos la función de suavizado "crs" la cual necesita
% ademas un valor de tau, en este caso tendremos que tau = 0.5
Z1 = crs(St,DEM,'K',K,'tau',0.5);
%%
% Ahora creamos el perfil longitudinal de la red hídrica de la cuenca
Z2 = crs(Sm,DEM,'K',K,'tau',0.5);
% Calculamos el ksn de la red hídrica
k = ksn(Sm,Z2,FA,0.45);
% Ploteamos el DEM con la paleta de colores parula y en UTM
imageschs(DEM,[],'colormap',parula,'colorbar',false,'ticklabels','nice');
hold on;
% Plotemamos encima la cuenca con bordes resaltados
Cr = plotdbfringe(FD,Sm,'colormap',magmacolor,'width',30);
hold on;
plotc(Sm,k);
% Escogemos la paleta de colores para mostrar el Ksn, en este caso
% utilizaremos la paleta "jet"
colormap(jet);
hx = colorbar;
hx.Label.String = 'k_{sn}';
hold off;
%%
h = figure();
set(h,'Units','normalized','Position',[0 0 1 .5]); 
subplot(1,2,1)
% Ploteamos el DEM en color gris
imageschs(DEM,[],'colormap',parula,'colorbar',true,'ticklabels','nice');
hold on
Cr = plotdbfringe(FD,Sm,'colormap',magmacolor,'width',30);
hold on;
% Ploteamos el rio sobre el DEM
plot(St,'k-')
hx1 = colorbar;
hx1.Label.String = 'Altura';
subplot(1,2,2)
% Utilizaremos la función "plotdz" para plotear el perfil longitudinal
% suavizado por la función crs
plotdz(St,Z1);
hold off
%%
%Escribir codigo para plotear los trunk rivers de cuencas seleccionadas en
%un mismo gráfico
