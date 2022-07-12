import os


def make_config(
        epipolar: str,
        half_window: int,
        prob_pt_selection: float
    ):
    with open('exp_config.txt', 'w') as f:
        f.write(epipolar)
        f.write('\n')
        f.write(str(half_window))
        f.write('\n')
        f.write(str(prob_pt_selection))
        f.write('\n')


def run_exps():
    base_dir = "/home/ronnypetson/repos/ORB_SLAM2/"
    seq_base_dir = "/home/ronnypetson/Documents/slam/"
    bin_fname = f"{base_dir}/Examples/Monocular/mono_euroc"
    ORB_voc = f"{base_dir}/Vocabulary/ORBvoc.txt"

    def id2calib():
        return "/home/ronnypetson/repos/ORB_SLAM2/Examples/Monocular/EuRoC.yaml"

    def id2seqdir(idx):
        return f"{seq_base_dir}/{idx}/mav0/cam0/data"

    def id2timestamps(idx):
        idx = ''.join(idx.split('_')[:2])
        return f"/home/ronnypetson/repos/ORB_SLAM2/Examples/Monocular/EuRoC_TimeStamps/{idx}.txt"

    cfg_epipolar = ['Epipolar', 'Default'] # ['NoGBA']
    cfg_half_window = [1]
    cfg_prob_pt_selection = [1.0]

    rep = 10
    num_curr_exps = 0
    num_curr_max_exps = 70
    seq_names = ["MH_03_medium", "MH_04_difficult", "MH_05_difficult"]
    for seq in seq_names:
        exp_seq_dir = f"exps/{seq}/"
        if not os.path.exists(exp_seq_dir):
            os.makedirs(exp_seq_dir)
        for ep in cfg_epipolar:
            for hw in cfg_half_window:
                for prob in cfg_prob_pt_selection:
                    for rep_num in range(rep):
                        print(f'Running seq={seq}, GBA={ep}, half-window={hw}, pt. prob={prob:.2f}')
                        run_dir = f"{exp_seq_dir}/{ep}_{hw}_{prob:.2f}_{rep_num}"
                        if os.path.exists(run_dir):
                            continue
                        os.makedirs(run_dir)
                        make_config(ep, hw, prob)
                        os.system(f"cp exp_config.txt {run_dir}")
                        cmd = f"{bin_fname} {ORB_voc} {id2calib()} {id2seqdir(seq)} {id2timestamps(seq)}"
                        cmd = f"{cmd} | grep csv_output > {run_dir}/run_output.csv"
                        os.system(cmd)
                        os.system(f"cp KeyFrameTrajectory.txt {run_dir}")
                        # os.system(f"cp timestamps_EuRoC.txt {run_dir}")
                        num_curr_exps += 1
                        if num_curr_exps == num_curr_max_exps:
                            return


if __name__ == '__main__':
    run_exps()
