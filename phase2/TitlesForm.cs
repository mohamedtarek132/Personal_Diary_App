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

namespace phase2
{
    public partial class TitlesForm : Form
    {
        string ordb = "Data source=orcl;User Id=scott;Password=tiger;";
        OracleConnection conn;
        int userId;
        public TitlesForm()
        {
            InitializeComponent();
        }

        private void TitlesForm_Load(object sender, EventArgs e)
        {
            conn = new OracleConnection(ordb);
            conn.Open();

            OracleCommand cmd = new OracleCommand();
            cmd.Connection = conn;
            cmd.CommandText = "retrieve_titles";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("userId", userId);
            cmd.Parameters.Add("titles", OracleDbType.RefCursor, ParameterDirection.Output);

            OracleDataReader dr = cmd.ExecuteReader();

            DataTable dataTable = new DataTable();
            dataTable.Load(dr);

            dataGridView1.DataSource = dataTable;

            dr.Close();
            conn.Dispose();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            foreach (DataGridViewRow row in dataGridView1.Rows)
            {
                if (!row.IsNewRow)
                {
                    if (row.Cells[1] != null && row.Cells[1].Value.ToString().ToLower().Contains(textBox1.Text.ToLower())
                    {
                        row.Visible = true;
                    }
                }
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            //go to log in
        }

        private void button2_Click(object sender, EventArgs e)
        {
            //go to diary form
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            //sort
        }
    }
}
