from scipy.spatial.transform import Rotation as R
import numpy as np

rots = [0, 90, 180, 270]
def rotations():
    lst = []
    for xr in rots:
        for yr in rots:
            for zr in rots:
                r = R.from_euler('xyz', [xr, yr, zr], degrees=True)
                m = np.round(r.as_matrix()).astype(np.int32)
                lst.append(m)

    arr = np.array(lst)
    v = np.unique(arr, axis=0)
    for idx, m in enumerate(v[::-1,:,:]):
        print(idx)
        print(m)
        print()

if __name__ == "__main__":
    rotations()
