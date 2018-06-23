page 50101 "Zoom"
{
    PageType = List;
    SourceTable = "Zoom Line";
    Editable = false;

    layout
    {
        area(content)
        {
            group("Page Information")
            {
                field("PK Value"; "PK Value"){}
                field("Source Table";"Source Table"){}
            }
        
            repeater(Group)
            {
                field("Field No.";"Field No."){}
                field("Field Name";"Field Name"){}
                field("Field Value";"Field Value"){}
            }
        }
    }
}