#/bin/python

# Loudspeaker impedance post-processing
# Copyright (C) Guillaume Pellerin



class Impedance(object):

    def __init__(self, U_r_path, U_hp_path, exc_path, R_c, f_s, f_min, f_max, options):
        import timeside

        self.U_r = self.get_stack(U_r_path)
        self.U_hp = self.get_stack(U_hp_path)

        self.R_c = R_c
        self.f_s = f_s
        self.f_min = f_min
        self.f_max = f_max
        self.options = options

        I_r = U_r./self.R_c

    def get_stack(self, audio_file):
        p = timeside.core.get_processor('decoder')(audio_file)
        l = timeside.core.get_processor('level')()
        p = (d|l)
        p.run()
        return p.frame_stack

    def process(self):
        li = len(I_r);
        fi = np.fft(self.I_r);
        fu = np.fft(self.U_hp);
        fz = fu./fi;
        self.f = [0:f_s/li:f_s];
        f = f(1:li);

    def plot(self):

        # get limit freq
        f_max_list = find(f > f_max);
        f_max_ind = f_max_list(1);
        f_min_list = find(f < f_min);
        f_min_ind = f_min_list(length(f_min_list));

        figure
        subplot(2,1,1);
        data = smooth(abs(fz),20);
        if option == 'lin'
            plot(f,data)
        elseif option == 'log'
            semilogx(f,data)
        end

        axis([f_min f_max 0 max(data(f_min_ind:f_max_ind))])
        xlabel('Fréquence (Hz)');
        ylabel('Amplitude (Ohm)');
        title(['Module de l impedance']);
        grid on

        subplot(2,1,2);
        data = smooth(unwrap(angle(fz)),20);
        if option == 'lin'
            plot(f,data)
        elseif option == 'log'
            semilogx(f,data)
        end
        axis([f_min f_max min(data(f_min_ind:f_max_ind)) max(data(f_min_ind:f_max_ind))]);
        xlabel('Fréquence (Hz)');
        ylabel('Amplitude (Rad)');
        title(['Phase de l impedance']);
        grid on


