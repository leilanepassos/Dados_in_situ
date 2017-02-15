%~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~%
%                                                                 %
%                                                                 %
%           Projeto de Pesquisa em Mudancas Climaticas            %
%            Instituto Nacional de Pesquisas Espaciais            %
%                                                                 %
%                                                                 %
%~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~%
%   ROTINA PARA PLOTAR TRANSECTO DE XBT DA COMISSÃO PIRATA XV     %
%                     DATA: 15/02/2017                            %
%~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~%
%                                                                 %
% author: Ocª.Leilane Passos                                      %                                  
% leilanepassos@gmail.com                                         %
%~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~%
%%
clear; close all; clc;

%-------------------------------------------------------------------------%
% Define Transectos que serão plotados
%-------------------------------------------------------------------------%
% trans = {'P1' 'P2' 'P3' 'P4'};
trans = {'P1'};
yis = 0:1:1499; yis = yis';          % valor máximo de profundidade do XBT;

%=========================================================================%
% LOOP TRANSECTOS
%=========================================================================%
for i = 1:length(trans)
    path = ['/home/leilane/Documents/ASSISTENTE_DE_PESQUISA/Marcelo_Santini/PIRATA_XBT/',trans{i},'/'];
    eval(['cd ' path]);

    arquivo = dir('*.dat');
    est     = 1:length(arquivo);

    %---------------------------------------------------------------------%
    % Lê e interpola todas as estações do transecto  
    for rad = 1:length(arquivo)
        
        A = importdata(arquivo(rad).name,' ',48); 
        temp_interp(:,rad) = interp1(A.data(:,1),A.data(:,2),yis', 'linear');

    end 
    %---------------------------------------------------------------------%

    %---------------------------------------------------------------------%
    % Plota Transecto  

    figure('inverthardcopy','off','color',[1 1 1],'papertype','a4'); hold on

    % Define variáveis do plote
    [m n] = size(temp_interp);
    YIS   = repmat(yis,[1 length(est)]);
    EST   = repmat(est,[1500 1]);
    marke = zeros(length(est),1)+(-1);
    
    % Plota Temperatura, estações e marcadores
    contourf(EST,-YIS,temp_interp,100); shading flat;
    plot(EST,-YIS,'k','markersize',[4], 'linewidth', 0.5);
    plot(est',marke,'vk','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'MarkerSize',4)

    % Define eixos e título
    ylabel('Profundidade(m)');
    xlabel('Estações');
    title (['XBT Pirata 2014 - ',trans{i},''])
    set(gca,'Xtick',est')
    set(gca,'XtickLabel',sprintf('%02g|',est'))
    set(gca, 'CLim', [min(min(temp_interp)), max(max(temp_interp))]);


    % Define colorbar
    hc = colorbar('vert');
    set(get(hc,'ylabel'),'String','Temperatura (^oC)');
    x1   = get(gca,'Position');
    x    = get(hc,'Position');
    x(3) = x(3)/2; 
    set(hc, 'Position',x)
    set(gca,'Position',x1)

    % Salva figura e fecha o plote
    saveas(gcf,['../FIGURAS/XBT_',trans{i},'_transecto.png'])
    close
    %---------------------------------------------------------------------%

    clear arquivo temp_interp path est A m n YIS EST marke hc x1 x
end
%=========================================================================%
% END LOOP TRANSECTOS
%=========================================================================%






