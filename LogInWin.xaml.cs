using Npgsql;
using System;
using System.Collections.Generic;
using System.Data.OleDb;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace WpfApp1
{
    /// <summary>
    /// Логика взаимодействия для LogInWin.xaml
    /// </summary>
    public partial class LogInWin : Window
    {
        public static string connstring;
        public static bool getConnection(NpgsqlConnection connection, string connString)
        {
            try
            {

                connection.ConnectionString = connString;
                connection.Open();
                return true;

            }
            catch (OleDbException XcpSQL)
            {
                foreach (OleDbError se in XcpSQL.Errors)
                {
                    MessageBox.Show(se.Message,
                    "SQL Error code " + se.NativeError);
                }
                return false;
            }
            catch (Exception e)
            {
                MessageBox.Show("WRONG USERNAME OR PASSWORD");
                return false;
            }
        }
        public LogInWin()
        {
            InitializeComponent();
        }
        private void loginbtn_Click(object sender, RoutedEventArgs e)
        {
            NpgsqlConnection conn = new NpgsqlConnection();
            connstring = "Server=localhost;Port=5432;Database=cargo_delivery;User Id=" + logintb.Text + ";Password=" + passwordtb.Text + ";" ;
            if (getConnection(conn, connstring))
            { MainWindow mainWindow1 = new MainWindow();
              this.Close();
              MessageBox.Show("Соединение с базой данных выполнено успешно");
              mainWindow1.Show();
            }
        }
        
    }
}
