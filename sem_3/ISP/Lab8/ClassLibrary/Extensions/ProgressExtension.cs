using System.Net.Http.Headers;

namespace ClassLibrary.Extensions
{
    public static class ProgressExtension
    {
        public static void ReportWritingBegan(this IProgress<string> progress)
        {
            progress.ReportMessage("\nWriting began in thread: ");
        }

        public static void ReportWritingEnded(this IProgress<string> progress)
        {
            progress.ReportMessage("\nWriting ended in thread: ");
        }
        public static void ReportCopyingBegan(this IProgress<string> progress)
        {
            progress.ReportMessage("\nCopying began in thread: ");
        }

        public static void ReportCopyingEnded(this IProgress<string> progress)
        {
            progress.ReportMessage("\nCopying ended in thread: ");
        }

        public static void ReportProgress(this IProgress<string> progress, string task, double percent)
        {
            progress.Report($"Task: {task}, Thread: {Environment.CurrentManagedThreadId}: {percent}%");         
        }

        private static void ReportMessage(this IProgress<string> progress, string message)
        {
            progress.Report($"{message}{Environment.CurrentManagedThreadId}\n");
        }
    }
}

