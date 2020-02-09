<#
.Synopsis
   Show WPF analog of MessageBox
.DESCRIPTION
   Show WPF analog of MessageBox. There are can be one or two buttons
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
#>
function Show-WpfMessageBoxDialog
{    
    [OutputType([Boolean])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true, Position=0)]
        [Alias("header")] 
        [string]
        $MessageHeader="This is a message header",
        [Parameter(Mandatory=$false, Position=1)]
        [Alias("body")] 
        [string]
        $MessageBody="",
        [Parameter(Mandatory=$false, Position=2)]
        [Alias("buttons")] 
        [string]
        $ButtonsTexts = "Ok"
    )

    Process
    {
            #$id = get-random;
            $id = "Main";
            $code = @"
            using System;
            using System.Collections.Generic;
            using System.Linq;
            using System.Text;
            using System.Threading;
            using System.Threading.Tasks;
            using System.Windows;
            using System.Windows.Controls;
            using System.Windows.Data;
            using System.Windows.Documents;
            using System.Windows.Input;
            using System.Windows.Markup;
            using System.Windows.Media;
            using System.Windows.Media.Imaging;
            using System.Windows.Navigation;
            using System.Windows.Shapes;
            using System.Xml;
            using System.IO;

            namespace WPFMessageBoxForPS
            {

                public class WPFMessageBox$id : Window
                {
                    string defaultxaml = @"<Grid xmlns=""http://schemas.microsoft.com/winfx/2006/xaml/presentation""
                    xmlns:x=""http://schemas.microsoft.com/winfx/2006/xaml""
                    xmlns:core=""clr-namespace:System;assembly=mscorlib""
                    Background=""Black"">
                <Grid.RowDefinitions>
                    <RowDefinition Height=""2*""/>
                    <RowDefinition Height=""6*""/>
                    <RowDefinition Height=""65""/>
                </Grid.RowDefinitions>

                <Grid.Resources>
                    <Style x:Key=""MyButtonStyle"" TargetType=""{x:Type Button}"">
                        <Style.Triggers>
                            <Trigger Property=""IsMouseOver"" Value=""True"">
                                <Setter Property=""Foreground"" Value=""White""/>
                                <Setter Property=""Background"" Value=""Chocolate""/>
                                <Setter Property=""FontSize"" Value=""16""/>
                                <Setter Property=""FontWeight"" Value=""Bold""/>
                                <Setter Property=""BorderThickness"" Value=""2""/>
                                <Setter Property=""BorderBrush"" Value=""WhiteSmoke""/>
                            </Trigger>
                        </Style.Triggers>
                        <Setter Property=""Background"" Value=""Black""></Setter>
                        <Setter Property=""Foreground"" Value=""WhiteSmoke""></Setter>
                        <Setter Property=""BorderThickness"" Value=""0""></Setter>
                        <Setter Property=""Template"">
                            <Setter.Value>
                                <ControlTemplate TargetType=""{x:Type Button}"">
                                    <Border Background=""{TemplateBinding Background}"" BorderBrush=""{TemplateBinding BorderBrush}"" 
                                                BorderThickness=""{TemplateBinding BorderThickness}"">
                                        <ContentPresenter HorizontalAlignment=""Center"" VerticalAlignment=""Center""/>
                                    </Border>
                                </ControlTemplate>
                            </Setter.Value>
                        </Setter>
                    </Style>
                </Grid.Resources>
                <GroupBox Grid.Row=""0"" BorderThickness=""1"" Foreground=""WhiteSmoke"" FontSize=""16"">
                    <TextBlock Margin=""5"" Name=""MessageHeader"" Text=""Заголовок сообщения"" Foreground=""WhiteSmoke""
                            FontSize=""14"" TextAlignment=""Center"" FontWeight=""Bold"" TextDecorations=""Underline"" 
                            TextWrapping=""Wrap""/>
                </GroupBox>
                <GroupBox Grid.Row=""1"" BorderThickness=""1"" Foreground=""WhiteSmoke"" FontSize=""12"">
                    <GroupBox.Header>
                        Additional info:
                    </GroupBox.Header>
                <TextBox Margin=""5"" Name=""MessageBody"" Text=""Тело сообщения"" Grid.Row=""1"" Background=""Black"" Foreground=""WhiteSmoke"" 
                            VerticalAlignment=""Top""
                            FontSize=""12"" VerticalScrollBarVisibility=""Auto"" HorizontalScrollBarVisibility=""Auto""
                            BorderThickness=""0"" TextWrapping=""Wrap""/>
                </GroupBox>
                <GroupBox Grid.Row=""2"" Margin=""5"">
                    <Grid Margin=""1"" Name=""btnGrid"">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width=""*""/>
                            <ColumnDefinition Width=""*""/>
                        </Grid.ColumnDefinitions>
                        <Button Margin=""2,4,2,2"" Name=""ButtonOk"" Grid.Column=""0"" Style=""{StaticResource MyButtonStyle}"">Ok</Button>
                        <Button Margin=""2,4,2,2"" Name=""ButtonCancel"" Grid.Column=""1"" Style=""{StaticResource MyButtonStyle}"">Cancel</Button>
                    </Grid>
                </GroupBox>
            </Grid>";

        
                    public Button ButtonOk;
                    public Button ButtonCancel;

                    private TextBox messageBody;
                    private TextBlock messageHeader;

                    public bool IsOneButton
                    {
                        set {
                            if (value)
                            {
                                ButtonCancel.Visibility = Visibility.Collapsed;
                                Grid.SetColumnSpan(ButtonOk, 2);
                            }
                            else
                            {
                                ButtonCancel.Visibility = Visibility.Visible;
                                Grid.SetColumnSpan(ButtonOk, 1);
                            }
                        }
                        get { return ButtonCancel.IsVisible; }
                    }


                    public string MessageBody
                    {
                        set { messageBody.Text = value; }
                        get { return messageBody.Text; }
                    }

                    public string MessageHeader
                    {
                        set { messageHeader.Text = value; }
                        get { return messageHeader.Text; }
                    }

                    public WPFMessageBox$id() 
                    {
                        InitializedComponent(defaultxaml,false);
                        IsOneButton = false;
                    }
                    public WPFMessageBox$id(bool isonebtn) 
                    {
                        InitializedComponent(defaultxaml,false);
                        IsOneButton = isonebtn;
                    }
                    public WPFMessageBox$id(string xamlFile, bool fromfile = false)
                    {
                        InitializedComponent(xamlFile, fromfile);
                    }



                    private void InitializedComponent(string xaml, bool fromfile = false)
                    {
                        // Новая форма
                        this.MaxWidth = 600;
                        this.MaxHeight = 450;
                        this.SizeToContent = SizeToContent.WidthAndHeight;
                        this.WindowStartupLocation = WindowStartupLocation.CenterScreen;
                        this.Title = "";
            

                        // Получаем содержимое XAML из переданной строки
                        DependencyObject rootElement;

                        if (fromfile)
                        {
                            using (FileStream fs = new FileStream(xaml, FileMode.Open))
                            {
                                rootElement = (DependencyObject)XamlReader.Load(fs);
                            }
                        }
                        else
                        {
                            //код не работает
                            //XmlDocument xmlDoc = new XmlDocument();
                            //xmlDoc.LoadXml(xaml);
                            //rootElement = (DependencyObject)XamlReader.Load(new System.Xml.XmlNodeReader(xmlDoc));
                            string tmpxaml = System.IO.Path.GetTempPath()+"xaml\\xaml" +
                                    (new Random()).Next(0, 100000).ToString() + ".xaml";

                            DirectoryInfo dirInfo = new DirectoryInfo(System.IO.Path.GetTempPath() + "\\xaml");
                            if (!dirInfo.Exists)
                            {
                                dirInfo.Create();
                            }
                            using (FileStream fstream = new FileStream(tmpxaml, FileMode.OpenOrCreate))
                            {
                                // преобразуем строку в байты
                                byte[] array = System.Text.Encoding.UTF8.GetBytes(xaml);
                                // запись массива байтов в файл
                                fstream.Write(array, 0, array.Length);
                            }
                            //using (StreamWriter fs = new StreamWriter(tmpxaml, Encoding.Default))
                            //{
                            //    fs.Write(xaml);
                            //}
                            using (FileStream fs = new FileStream(tmpxaml, FileMode.Open))
                            {
                                rootElement = (DependencyObject)XamlReader.Load(fs);
                            }
                            FileInfo fileInfo = new FileInfo(tmpxaml);
                            if(fileInfo.Exists)
                            {
                                fileInfo.Delete();//если в темпе не удалять то со временем переполнится темп и ps не запустится :(
                            }
                        }
            
                        this.Content = rootElement;
                        ButtonOk = (Button)LogicalTreeHelper.FindLogicalNode(rootElement, "ButtonOk");
                        ButtonCancel = (Button)LogicalTreeHelper.FindLogicalNode(rootElement, "ButtonCancel");
                        messageHeader = (TextBlock)LogicalTreeHelper.FindLogicalNode(rootElement, "MessageHeader");
                        messageBody = (TextBox)LogicalTreeHelper.FindLogicalNode(rootElement, "MessageBody");
            
                        // Обработчик события клика
                        ButtonOk.Click += DialogResult_Click;
                        ButtonCancel.Click += DialogResult_Click;
                    }

                    private void DialogResult_Click(object sender, RoutedEventArgs e)
                    {
                        Button senderbutton = sender as Button;
                        if (null!=senderbutton && senderbutton.Name == "ButtonOk")
                        {
                            DialogResult = true;
                        }
                        else
                        {
                            DialogResult = false;
                        }
                        this.Close();
                    }
                }

            }
"@

            $assemblies = ("System.Core","System.Xml.Linq","System.Data","System.Xml", "System.Data.DataSetExtensions", "Microsoft.CSharp","PresentationCore", `
                        "PresentationFramework", "System", "System.Xaml", "WindowsBase");

            Add-Type -ReferencedAssemblies $assemblies -TypeDefinition $code -Language CSharp;



            $btnNamesArray = $ButtonsTexts.Split(",");
            

            if ($btnNamesArray.Count -gt 1)
            {
                $msgBox = New-Object -TypeName "WPFMessageBoxForPS.WPFMessageBox$id" -ArgumentList @(,$false);;
                $msgBox.ButtonOk.Content = $btnNamesArray[0];
                $msgBox.ButtonCancel.Content = $btnNamesArray[1];
            }
            else
            {
                $msgBox = New-Object -TypeName "WPFMessageBoxForPS.WPFMessageBox$id" -ArgumentList @(,$true);
                $msgBox.ButtonOk.Content = $btnNamesArray[0];                
            }

            $msgBox.MessageBody = $MessageBody;
            $msgBox.MessageHeader = $MessageHeader;

            return $msgBox.ShowDialog();
    }
}