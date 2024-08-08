function SpiralWaves(StimProtocol)
ncols=128;
nrows=128;
dur=25000;
h=2.0;
h2=h^2;
dt=0.15;
Iex=30;
mu=1.0;
Gx=1; Gy=Gx/mu;
a=0.13; b=0.013; c1=0.26; c2=0.1; d=1.0;
v=zeros(nrows,ncols);
r=v;
% Set initial stim current and pattern
iex=zeros(nrows,ncols);
if StimProtocol==1
    iex(62:67,62:67)=Iex;
else
    iex(:,1)=Iex;
end
% Setup image
ih=imagesc(v); set(ih,'cdatamapping','direct')
colormap(hot); axis image off; th=title('');
set(gcf,'position',[500 600 256 256],'color',[1 1 1],'menubar','none')
% Create 'Quit' pushbutton in figure window
uicontrol('units','normal','position',[.45 .02 .13 .07], ...
    'callback','set(gcf,''userdata'',1)',...
    'fontsize',10,'string','Quit');
n=0;
k=0;
done=0;
n1e=20;
switch StimProtocol
    case 1 % Two-point stimulation
        n2b=3800;
        n2e=3900;
    case 2 % Cross-field stimulation
        n2b=5400;
        n2e=5420;
end
while ~done
    if n == n1e
        iex=zeros(nrows,ncols);
    end
    if n == n2b
        switch StimProtocol
            case 1
                iex(62:67,49:54)=Iex;
            case 2
                iex(end,:)=Iex;
        end
    end
    if n == n2e
        iex=zeros(nrows,ncols);
    end
    vv=[[0 v(2,:) 0];[v(:,2) v v(:,end-1)];[0 v(end-1,:) 0]];
    vxx=(vv(2:end-1,1:end-2) + vv(2:end-1,3:end) -2*v)/h2;
    vyy=(vv(1:end-2,2:end-1) + vv(3:end,2:end-1) -2*v)/h2;
    dvdt=c1*v.*(v-a).*(1-v)-c2*v.*r+iex+Gx*vxx+Gy*vyy;
    v_new=v + dvdt*dt;
    drdt=b*(v-d*r);
    r=r + drdt*dt;
    v=v_new; clear v_new
    m=1+round(63*v); m=max(m,1); m=min(m,64);
    set(ih,'cdata',m);
    set(th,'string',sprintf('%d %0.2f %0.2f',n,v(1,1),r(1,1)))
    drawnow
    % Write every 500th frame to movie
    if rem(n,500)==0
        k=k+1;
        mov(k)=getframe;
    end
    n=n+1;
    done=(n > dur);
    if max(v(:)) < 1.0e-4, done=1; end
    if ~isempty(get(gcf,'userdata')), done=1; end
end
if isunix, sep='/'; else sep='\'; end
[fn,pn]=uiputfile([pwd sep 'SpiralWaves.avi'],'Save movie as:');
if ischar(fn)
    video_file = VideoWriter(fullfile(pn, fn), 'Motion JPEG AVI');
    video_file.Quality = 75;
    open(video_file);
    writeVideo(video_file, mov);
    close(video_file);
else
    disp('User pressed cancel')
end
close(gcf)