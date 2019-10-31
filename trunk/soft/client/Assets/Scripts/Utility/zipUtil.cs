using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ICSharpCode.SharpZipLib.Zip;
using System.IO;
using System;

public class zipUtil
{
    static void GetFiles(string dir, List<string> files) {
        string[] filenames = Directory.GetFiles(dir);
        for (int i = 0; i < filenames.Length; ++i) {
            if (filenames[i].EndsWith(".meta")) {
                continue;
            }
            if (filenames[i].EndsWith("ver.txt")) {
                continue;
            }
            files.Add(filenames[i]);
        }
        string[] dirs = Directory.GetDirectories(dir);
        for (int i = 0; i < dirs.Length; ++i) {
            GetFiles(dirs[i], files);
        }
    }

    private static int avg = 1024 * 1024 * 10;

    public delegate void CompressDirProgress(string name, float progress);

    public delegate void CompressDirFinish();

    public static void CompressDir(string srcdir, string filepath, CompressDirProgress cdp, CompressDirFinish cdf) {
        List<string> filenames = new List<string>();
        GetFiles(srcdir, filenames);
        ZipOutputStream s = new ZipOutputStream(File.Create(filepath));
        s.SetLevel(6);
        ZipEntry entry = null;
        FileStream fs = null;
        for (int m = 0; m < filenames.Count; ++m) {
            string file = filenames[m];
            if (file.EndsWith(".meta")) {
                continue;
            }
            fs = File.OpenRead(file);
            byte[] buffer = new byte[avg];
            string file1 = file.Replace(srcdir, "");
            while (file1[0] == '/' || file1[0] == '\\') {
                file1 = file1.Substring(1);
            }
            entry = new ZipEntry(file1);
            entry.DateTime = DateTime.Now;
            entry.Size = fs.Length;
            s.PutNextEntry(entry);
            for (int i = 0; i < fs.Length; i += avg) {
                if (i + avg > fs.Length) {
                    //不足100MB的部分写剩余部分
                    buffer = new byte[fs.Length - i];
                }
                fs.Read(buffer, 0, buffer.Length);
                s.Write(buffer, 0, buffer.Length);
            }
            cdp(file, m / (float)filenames.Count);
        }
        if (fs != null) {
            fs.Close();
            fs = null;
        }
        if (entry != null)
            entry = null;
        s.Close();
        GC.Collect();
        cdf();
    }

    public delegate void DecompressDirProgress(string name, float progress);

    public delegate void DecompressDirFinish();

    public static IEnumerator DecompressDir(string srcfile, string destdir, DecompressDirProgress ddp, DecompressDirFinish ddf) {
        ZipInputStream s = new ZipInputStream(File.OpenRead(srcfile));
        int num = 0;
        ZipEntry theEntry;
        while ((theEntry = s.GetNextEntry()) != null) {
            num++;
        }
        s.Close();
        s = new ZipInputStream(File.OpenRead(srcfile));
        int m = 0;
        while ((theEntry = s.GetNextEntry()) != null) {
            string fileName = destdir + "/" + theEntry.Name.Replace('\\', '/');
            string directoryName = Path.GetDirectoryName(fileName);
            if (!Directory.Exists(directoryName)) {
                Directory.CreateDirectory(directoryName);
            }
            if (fileName != String.Empty) {
                FileStream streamWriter = File.Create(fileName);
                int size = 2048;
                byte[] data = new byte[2048];
                while (true) {
                    size = s.Read(data, 0, data.Length);
                    if (size > 0) {
                        streamWriter.Write(data, 0, size);
                    }
                    else {
                        break;
                    }
                }
                streamWriter.Close();
            }
            ddp(theEntry.Name, m / (float)num);
            yield return new WaitForEndOfFrame();
            m++;
        }
        s.Close();
        ddf();
    }
}
