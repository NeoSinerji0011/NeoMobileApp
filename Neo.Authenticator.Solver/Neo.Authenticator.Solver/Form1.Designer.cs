
namespace Neo.Authenticator.Solver
{
    partial class Form1
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.btnParseQrCode = new System.Windows.Forms.Button();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.txtSecretKey = new System.Windows.Forms.TextBox();
            this.gbCodeGenerate = new System.Windows.Forms.GroupBox();
            this.cbInsuranceType = new System.Windows.Forms.ComboBox();
            this.txtCode = new System.Windows.Forms.TextBox();
            this.btnCodeGenerate = new System.Windows.Forms.Button();
            this.gbGoogleAuthenticatorSolver = new System.Windows.Forms.GroupBox();
            this.txtGoogleQrCodeResult = new System.Windows.Forms.TextBox();
            this.btnGoogleQrCodeResolve = new System.Windows.Forms.Button();
            this.groupBox1.SuspendLayout();
            this.gbCodeGenerate.SuspendLayout();
            this.gbGoogleAuthenticatorSolver.SuspendLayout();
            this.SuspendLayout();
            // 
            // btnParseQrCode
            // 
            this.btnParseQrCode.Location = new System.Drawing.Point(19, 22);
            this.btnParseQrCode.Name = "btnParseQrCode";
            this.btnParseQrCode.Size = new System.Drawing.Size(106, 23);
            this.btnParseQrCode.TabIndex = 0;
            this.btnParseQrCode.Text = "Qr Code Okut";
            this.btnParseQrCode.UseVisualStyleBackColor = true;
            this.btnParseQrCode.Click += new System.EventHandler(this.btnParseQrCode_Click);
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.txtSecretKey);
            this.groupBox1.Controls.Add(this.btnParseQrCode);
            this.groupBox1.Location = new System.Drawing.Point(12, 12);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(374, 93);
            this.groupBox1.TabIndex = 1;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Secret Key";
            // 
            // txtSecretKey
            // 
            this.txtSecretKey.Location = new System.Drawing.Point(19, 51);
            this.txtSecretKey.Name = "txtSecretKey";
            this.txtSecretKey.ReadOnly = true;
            this.txtSecretKey.Size = new System.Drawing.Size(342, 23);
            this.txtSecretKey.TabIndex = 1;
            // 
            // gbCodeGenerate
            // 
            this.gbCodeGenerate.Controls.Add(this.cbInsuranceType);
            this.gbCodeGenerate.Controls.Add(this.txtCode);
            this.gbCodeGenerate.Controls.Add(this.btnCodeGenerate);
            this.gbCodeGenerate.Location = new System.Drawing.Point(12, 122);
            this.gbCodeGenerate.Name = "gbCodeGenerate";
            this.gbCodeGenerate.Size = new System.Drawing.Size(374, 93);
            this.gbCodeGenerate.TabIndex = 1;
            this.gbCodeGenerate.TabStop = false;
            this.gbCodeGenerate.Text = "Kod Oluştur";
            // 
            // cbInsuranceType
            // 
            this.cbInsuranceType.FormattingEnabled = true;
            this.cbInsuranceType.Location = new System.Drawing.Point(131, 22);
            this.cbInsuranceType.Name = "cbInsuranceType";
            this.cbInsuranceType.Size = new System.Drawing.Size(230, 23);
            this.cbInsuranceType.TabIndex = 2;
            // 
            // txtCode
            // 
            this.txtCode.Location = new System.Drawing.Point(19, 51);
            this.txtCode.Name = "txtCode";
            this.txtCode.ReadOnly = true;
            this.txtCode.Size = new System.Drawing.Size(342, 23);
            this.txtCode.TabIndex = 1;
            // 
            // btnCodeGenerate
            // 
            this.btnCodeGenerate.Location = new System.Drawing.Point(19, 22);
            this.btnCodeGenerate.Name = "btnCodeGenerate";
            this.btnCodeGenerate.Size = new System.Drawing.Size(106, 23);
            this.btnCodeGenerate.TabIndex = 0;
            this.btnCodeGenerate.Text = "Kod Oluştur";
            this.btnCodeGenerate.UseVisualStyleBackColor = true;
            this.btnCodeGenerate.Click += new System.EventHandler(this.btnCodeGenerate_Click);
            // 
            // gbGoogleAuthenticatorSolver
            // 
            this.gbGoogleAuthenticatorSolver.Controls.Add(this.txtGoogleQrCodeResult);
            this.gbGoogleAuthenticatorSolver.Controls.Add(this.btnGoogleQrCodeResolve);
            this.gbGoogleAuthenticatorSolver.Location = new System.Drawing.Point(417, 12);
            this.gbGoogleAuthenticatorSolver.Name = "gbGoogleAuthenticatorSolver";
            this.gbGoogleAuthenticatorSolver.Size = new System.Drawing.Size(557, 203);
            this.gbGoogleAuthenticatorSolver.TabIndex = 1;
            this.gbGoogleAuthenticatorSolver.TabStop = false;
            this.gbGoogleAuthenticatorSolver.Text = "Google Authenticator Secret Key";
            // 
            // txtGoogleQrCodeResult
            // 
            this.txtGoogleQrCodeResult.Location = new System.Drawing.Point(19, 51);
            this.txtGoogleQrCodeResult.Multiline = true;
            this.txtGoogleQrCodeResult.Name = "txtGoogleQrCodeResult";
            this.txtGoogleQrCodeResult.ReadOnly = true;
            this.txtGoogleQrCodeResult.Size = new System.Drawing.Size(532, 146);
            this.txtGoogleQrCodeResult.TabIndex = 1;
            // 
            // btnGoogleQrCodeResolve
            // 
            this.btnGoogleQrCodeResolve.Location = new System.Drawing.Point(19, 22);
            this.btnGoogleQrCodeResolve.Name = "btnGoogleQrCodeResolve";
            this.btnGoogleQrCodeResolve.Size = new System.Drawing.Size(106, 23);
            this.btnGoogleQrCodeResolve.TabIndex = 0;
            this.btnGoogleQrCodeResolve.Text = "Qr Code Okut";
            this.btnGoogleQrCodeResolve.UseVisualStyleBackColor = true;
            this.btnGoogleQrCodeResolve.Click += new System.EventHandler(this.btnGoogleQrCodeResolve_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1075, 279);
            this.Controls.Add(this.gbCodeGenerate);
            this.Controls.Add(this.gbGoogleAuthenticatorSolver);
            this.Controls.Add(this.groupBox1);
            this.Name = "Form1";
            this.Text = "Authenticator Solver";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.gbCodeGenerate.ResumeLayout(false);
            this.gbCodeGenerate.PerformLayout();
            this.gbGoogleAuthenticatorSolver.ResumeLayout(false);
            this.gbGoogleAuthenticatorSolver.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button btnParseQrCode;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.TextBox txtSecretKey;
        private System.Windows.Forms.GroupBox gbCodeGenerate;
        private System.Windows.Forms.TextBox txtCode;
        private System.Windows.Forms.Button btnCodeGenerate;
        private System.Windows.Forms.ComboBox cbInsuranceType;
        private System.Windows.Forms.GroupBox gbGoogleAuthenticatorSolver;
        private System.Windows.Forms.TextBox txtGoogleQrCodeResult;
        private System.Windows.Forms.Button btnGoogleQrCodeResolve;
    }
}

