// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

pageextension 50100 CustomerListZoom extends "Customer List"
{
    actions
    {
        addlast(Processing)
        {
            action("Zoom In")
            {
                CaptionML = ENG='Show All Fields',
                            ENU='Show All Fields';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Database;
            }
        }
    }
}