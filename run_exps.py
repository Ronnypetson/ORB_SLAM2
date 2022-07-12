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
    seq_base_dir = "/home/ronnypetson/Documents/kitti/gray/dataset/sequences/"
    bin_fname = f"{base_dir}/Examples/Monocular/mono_kitti"
    ORB_voc = f"{base_dir}/Vocabulary/ORBvoc.txt"

    def id2calib(idx):
        if idx < 3:
            return f"{base_dir}/Examples/Monocular/KITTI00-02.yaml"
        elif idx == 3:
            return f"{base_dir}/Examples/Monocular/KITTI03.yaml"
        else:
            return f"{base_dir}/Examples/Monocular/KITTI04-12.yaml"

    def id2seqdir(idx):
        return f"{seq_base_dir}/{idx:02d}/"

    cfg_epipolar = ['Epipolar'] # ['NoGBA'] # ['Epipolar', 'Default']
    cfg_half_window = [1, 2, 4]
    cfg_prob_pt_selection = [0.25, 0.5, 1.0]

    if not os.path.exists('exps'):
        os.makedirs('exps')

    rep = 1
    num_curr_exps = 0
    num_curr_max_exps = 70
    for seq in range(11): # [0, 2, 5, 6, 7, 9]
        for ep in cfg_epipolar:
            for hw in cfg_half_window:
                for prob in cfg_prob_pt_selection:
                    for rep_num in range(rep):
                        print(f'Running seq={seq}, GBA={ep}, half-window={hw}, pt. prob={prob:.2f}')
                        run_dir = f"exps/{ep}/{hw}/{prob:.2f}/{seq:02d}/{rep_num}/"
                        # if os.path.exists(run_dir):
                        #     continue
                        os.makedirs(run_dir)
                        make_config(ep, hw, prob)
                        os.system(f"cp exp_config.txt {run_dir}")
                        cmd = f"{bin_fname} {ORB_voc} {id2calib(seq)} {id2seqdir(seq)}"
                        cmd = f"{cmd} | grep csv_output > {run_dir}/run_output.csv"
                        os.system(cmd)
                        os.system(f"cp KeyFrameTrajectory.txt {run_dir}")
                        os.system(f"cp timestamps_KITTI.txt {run_dir}")
                        # num_curr_exps += 1
                        # if num_curr_exps == num_curr_max_exps:
                        #     return


if __name__ == '__main__':
    run_exps()
