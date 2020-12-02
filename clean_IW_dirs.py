# 20201028, xing
# find common set of IW{1,2,3} subswath directories to decide which common set to retain.

import os

import shutil


# It assumes a predefined layout of ./master and ./slaves dirs
# as created by tops stack processor.
def figure_out_common_iw_dirs(topDirPath):

    # get names of IW subdirs under master dir as set
    masterDirPath = os.path.join(topDirPath, "referance")

    namesOfIWDirsInMasterDir = set()
    entries = os.scandir(masterDirPath)
    for entry in entries:
        if not entry.is_dir() or not entry.name.startswith("IW"):
            continue
        namesOfIWDirsInMasterDir.add(entry.name)
    print("IW dirs under master dir:", namesOfIWDirsInMasterDir)

    # find IW subdirs under slaves dirs and save as d,
    # a map from slave date to set of names of IW dirs = {}
    slavesDirPath = os.path.join(topDirPath, "secondarys")

    d = {}
    for dirPath, dirNames, files in os.walk(slavesDirPath, topdown=False):
        tmp = dirPath.split(os.sep)
        # only check for subdirs like .../slaves/20190424/IW3
        if not tmp[-1].startswith("IW"):
            continue
        slaveDate = tmp[-2]
        iwName = tmp[-1]
        if slaveDate not in d:
            d[slaveDate] = set()
        d[slaveDate].add(iwName)
    print("IW dirs under slave dirs:", d)

    # get intersection of all iw dirs
    s = namesOfIWDirsInMasterDir
    for key, value in d.items():
        s = s.intersection(value)
    print("common IW dirs:", s)

    # a set is returned
    return s


# remove IW dirs not in commonIWNameSet
def clean_iw_dirs(topDirPath, commonIWNameSet):

    # figure files and dirs to delete
    dirsToDelete = []

    # check master dir
    masterDirPath = os.path.join(topDirPath, "referance")
    entries = os.scandir(masterDirPath)
    for entry in entries:
        if not entry.is_dir() or not entry.name.startswith("IW"):
            continue
        if entry.name in commonIWNameSet:
            continue
        dirsToDelete.append(os.path.join(masterDirPath, entry.name))

    # check slave dirs
    slavesDirPath = os.path.join(topDirPath, "secondarys")
    for dirPath, dirNames, files in os.walk(slavesDirPath, topdown=False):
        tmp = dirPath.split(os.sep)
        # only check for subdirs like .../slaves/20190424/IW3
        if not tmp[-1].startswith("IW"):
            continue
        if tmp[-1] in commonIWNameSet:
            continue
        dirsToDelete.append(os.path.join(slavesDirPath, tmp[-2], tmp[-1]))
    print("dirs to delete:", dirsToDelete)

    # remove dirs and associated xml files not needed
    for dirPath in dirsToDelete:
        print("deleting dir", dirPath)
        shutil.rmtree(dirPath)
        filePath = dirPath + ".xml"
        print("deleting file", filePath)
        os.remove(filePath)


def main():
    topDirPath = "."
    commonIWNameSet = figure_out_common_iw_dirs(topDirPath)
    clean_iw_dirs(topDirPath, commonIWNameSet)


if __name__ == "__main__":
    main()
