namespace phase2
{
    partial class DiaryForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
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
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            label1 = new Label();
            button2 = new Button();
            button1 = new Button();
            button3 = new Button();
            textBox1 = new TextBox();
            pictureBox1 = new PictureBox();
            textBox2 = new TextBox();
            button4 = new Button();
            ((System.ComponentModel.ISupportInitialize)pictureBox1).BeginInit();
            SuspendLayout();
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Font = new Font("Segoe UI", 25F);
            label1.Location = new Point(12, 19);
            label1.Name = "label1";
            label1.Size = new Size(112, 57);
            label1.TabIndex = 10;
            label1.Text = "Title:";
            label1.Click += label1_Click;
            // 
            // button2
            // 
            button2.Font = new Font("Segoe UI", 15F);
            button2.Location = new Point(564, 31);
            button2.Name = "button2";
            button2.Size = new Size(97, 47);
            button2.TabIndex = 17;
            button2.Text = "Save";
            button2.UseVisualStyleBackColor = true;
            // 
            // button1
            // 
            button1.Font = new Font("Segoe UI", 15F);
            button1.Location = new Point(667, 31);
            button1.Name = "button1";
            button1.Size = new Size(111, 47);
            button1.TabIndex = 18;
            button1.Text = "Delete";
            button1.UseVisualStyleBackColor = true;
            // 
            // button3
            // 
            button3.Font = new Font("Segoe UI", 10F);
            button3.Location = new Point(687, 402);
            button3.Name = "button3";
            button3.Size = new Size(101, 36);
            button3.TabIndex = 19;
            button3.Text = "Log Out";
            button3.UseVisualStyleBackColor = true;
            // 
            // textBox1
            // 
            textBox1.Location = new Point(21, 98);
            textBox1.Multiline = true;
            textBox1.Name = "textBox1";
            textBox1.Size = new Size(517, 284);
            textBox1.TabIndex = 20;
            // 
            // pictureBox1
            // 
            pictureBox1.Location = new Point(562, 98);
            pictureBox1.Name = "pictureBox1";
            pictureBox1.Size = new Size(216, 284);
            pictureBox1.TabIndex = 21;
            pictureBox1.TabStop = false;
            // 
            // textBox2
            // 
            textBox2.Location = new Point(143, 31);
            textBox2.Name = "textBox2";
            textBox2.Size = new Size(310, 27);
            textBox2.TabIndex = 22;
            // 
            // button4
            // 
            button4.Font = new Font("Segoe UI", 10F);
            button4.Location = new Point(12, 402);
            button4.Name = "button4";
            button4.Size = new Size(101, 36);
            button4.TabIndex = 23;
            button4.Text = "Back";
            button4.UseVisualStyleBackColor = true;
            // 
            // DiaryForm
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(800, 450);
            Controls.Add(button4);
            Controls.Add(textBox2);
            Controls.Add(pictureBox1);
            Controls.Add(textBox1);
            Controls.Add(button3);
            Controls.Add(button1);
            Controls.Add(button2);
            Controls.Add(label1);
            Name = "DiaryForm";
            Text = "DiaryForm";
            ((System.ComponentModel.ISupportInitialize)pictureBox1).EndInit();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Label label1;
        private Button button2;
        private Button button1;
        private Button button3;
        private TextBox textBox1;
        private PictureBox pictureBox1;
        private TextBox textBox2;
        private Button button4;
    }
}