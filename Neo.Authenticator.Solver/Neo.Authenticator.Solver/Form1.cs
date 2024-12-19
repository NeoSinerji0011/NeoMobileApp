using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.Text.RegularExpressions;
using System.Web;
using System.Windows.Forms;
using WinAuth;
using ZXing;
using ZXing.Common;

namespace Neo.Authenticator.Solver
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void btnParseQrCode_Click(object sender, EventArgs e)
        {
            try
            {
                var openDialog = new OpenFileDialog
                {
                    Filter = "Resim Dosyaları|*.png;*.jpg;*.jpeg;*.gif;*.bmp"
                };
                if (openDialog.ShowDialog() == DialogResult.OK)
                {
                    string fileName = openDialog.FileName;

                    if (fileName != null)
                    {
                        using var barcodeBitmap = new Bitmap(fileName);
                        var reader = new BarcodeReader
                        {
                            AutoRotate = true,
                            TryInverted = true,
                            Options = new DecodingOptions { TryHarder = true }
                        };

                        var res = reader.Decode(barcodeBitmap);
                        var pattern = new Regex("secret=([A-Z].*?)[&|}]");
                        if (pattern.IsMatch(res.Text))
                        {
                            txtSecretKey.Text = pattern.Match(res.Text).Groups[1].Value;
                        }
                        else
                        {
                            txtSecretKey.Text = "Kod Bulunamadı";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        private void btnCodeGenerate_Click(object sender, EventArgs e)
        {
            txtCode.Text = CodeGenerate((InsuranceType)cbInsuranceType.SelectedValue, txtSecretKey.Text);
        }

        public string CodeGenerate(InsuranceType type, string secretKey)
        {
            switch (type)
            {
                case InsuranceType.AtlasSigorta:
                case InsuranceType.BereketSigorta:
                case InsuranceType.CorpusSigorta:
                case InsuranceType.DogaSigorta:
                case InsuranceType.EthicaSigorta:
                case InsuranceType.GroupamaSigorta:
                case InsuranceType.HdiSigorta:
                case InsuranceType.NeovaSigorta:
                case InsuranceType.TmtSigorta:
                case InsuranceType.TurkNipponSigorta:
                    return GuildWars(secretKey);
                case InsuranceType.AnaSigorta:
                case InsuranceType.GriSigorta:
                case InsuranceType.KoruSigorta:
                    return Microsoft(secretKey);
                default:
                    return GuildWars(secretKey);
            }
        }


        private string GuildWars(string secretKey)
        {
            try
            {
                GuildWarsAuthenticator authenticator = new GuildWarsAuthenticator();
                authenticator.Enroll(secretKey);
                return authenticator.CurrentCode;
            }
            catch (Exception ex)
            {
                if (ex.Message.IndexOf("Illegal character") != -1)
                {
                    return "Illegal character";
                }
            }
            return string.Empty;
        }

        private static string Microsoft(string secretKey)
        {
            try
            {
                MicrosoftAuthenticator authenticator = new MicrosoftAuthenticator();
                authenticator.Enroll(secretKey);
                return authenticator.CurrentCode;
            }
            catch (Exception ex)
            {
                if (ex.Message.IndexOf("Illegal character") != -1)
                {
                    return "Illegal character";
                }
            }
            return string.Empty;
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            var list = new List<Insurance>();
            foreach (var insurance in Enum.GetValues(typeof(InsuranceType)))
            {
                var _enum = (InsuranceType)Enum.Parse(typeof(InsuranceType), insurance.ToString());
                list.Add(new Insurance
                {
                    Name = _enum.ToString(),
                    Type = _enum
                });
            }
            cbInsuranceType.DataSource = list;
            cbInsuranceType.ValueMember = "Type";
            cbInsuranceType.DisplayMember = "Name";
        }

        private void btnGoogleQrCodeResolve_Click(object sender, EventArgs e)
        {
            try
            {
                var openDialog = new OpenFileDialog
                {
                    Filter = "Resim Dosyaları|*.png;*.jpg;*.jpeg;*.gif;*.bmp"
                };
                if (openDialog.ShowDialog() == DialogResult.OK)
                {
                    string fileName = openDialog.FileName;
                    var barcodeBitmap = (Bitmap)Bitmap.FromFile(fileName);
                    QrCodeResolve(barcodeBitmap);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        private void QrCodeResolve(Bitmap barcodeBitmap)
        {
            txtGoogleQrCodeResult.Text = string.Empty;

            BarcodeReader reader = new BarcodeReader
            {
                AutoRotate = true,
                TryInverted = true,
                Options = new DecodingOptions { TryHarder = true }
            };
           
            Result res = reader.Decode(barcodeBitmap);

            if (res != null && res.Text != null && res.Text.StartsWith("otpauth-migration://offline"))
            {
                var psi = new ProcessStartInfo(@"C:\Users\muhac\go\bin\otpauth.exe", $"-link \"{res.Text}\"");
                psi.RedirectStandardOutput = true;
                psi.WindowStyle = ProcessWindowStyle.Hidden;
                psi.UseShellExecute = false;
                psi.WorkingDirectory = @"";
                var proc = Process.Start(psi);

                var myOutput = proc.StandardOutput;
                proc.WaitForExit(2000);
                if (proc.HasExited)
                {
                    string output = myOutput.ReadToEnd();

                    var lines = output.Split("\n");

                    foreach (var item in lines)
                    {
                        if (string.IsNullOrEmpty(item?.Trim())) continue;
                        var match = Regex.Match(item, @"otpauth:/\/totp\/(.*?):.*?secret=(.*)");
                        txtGoogleQrCodeResult.Text += HttpUtility.UrlDecode(match.Groups[1].Value) + " - " + match.Groups[2] + Environment.NewLine;
                    }
                }
            }
            else if (res == null && (barcodeBitmap.Width > 1500 && barcodeBitmap.Height > 1500))
            {
                Bitmap resized = new Bitmap(barcodeBitmap, new Size(barcodeBitmap.Width / 2, barcodeBitmap.Height / 2));
                QrCodeResolve(resized);
            }
            else
            {
                Console.WriteLine("Kare kod okumasından gelen kod Google Authenticator uygulamasına ait değil. Okunan değer : " + res?.Text);
            }
        }
    }
}
