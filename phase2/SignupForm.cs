using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Oracle.DataAccess.Client;
using Oracle.DataAccess.Types;


namespace phase2
{
    public partial class SignupForm : Form
    {
        string ordb = "Data source=orcl;User Id=scott;Password=tiger;";
        OracleConnection conn;
        public SignupForm()
        {
            InitializeComponent();
        }

        private void SignupForm_Load(object sender, EventArgs e)
        {
            conn = new OracleConnection(ordb);
        }

        private void button2_Click(object sender, EventArgs e)
        {
            conn.Open();

            OracleCommand cmd = new OracleCommand();
            cmd.Connection = conn;
            cmd.CommandText = "insert into diary_users values (DIARY_USER_SEQ.NEXTVAL, :username, :password, 'N')";
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.Add("username", textBox1.Text);
            cmd.Parameters.Add("password", textBox2.Text);
            if (textBox2.Text.Equals(textBox3.Text))
            {
                int r = cmd.ExecuteNonQuery();

                if (r == -1)
                {
                    MessageBox.Show("Username already taken! Try another one.");
                }
            }
            else
            {
                MessageBox.Show("Password doesn't match!");
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            //go to login page
        }
    }
}
