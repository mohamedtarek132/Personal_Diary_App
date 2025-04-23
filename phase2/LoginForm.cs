using Oracle.DataAccess.Client;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace phase2
{
    public partial class LoginForm : Form
    {
        string ordb = "Data source=orcl;User Id=scott;Password=tiger;";
        OracleConnection conn;
        public LoginForm()
        {
            InitializeComponent();
        }

        private void LoginForm_Load(object sender, EventArgs e)
        {
            conn = new OracleConnection(ordb);
        }

        private void button2_Click(object sender, EventArgs e)
        {
            conn.Open();

            OracleCommand cmd = new OracleCommand();
            cmd.Connection = conn;
            cmd.CommandText = "VALIDATE_USER";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("username", textBox1.Text);
            cmd.Parameters.Add("password", textBox2.Text);
            cmd.Parameters.Add("userId", OracleDbType.Int32, ParameterDirection.Output);
            cmd.ExecuteNonQuery();
            if (cmd.Parameters["userId"].Value.ToString().Equals("-1"))
            {
                MessageBox.Show("Username or Password is incorrect or doesn't exist!");
            }
            else
            {
                int userId = Convert.ToInt32(cmd.Parameters["userId"].Value.ToString());
                //go to titles form
            }

        }

        private void button1_Click(object sender, EventArgs e)
        {
            //go to sign up form
        }
    }
}
