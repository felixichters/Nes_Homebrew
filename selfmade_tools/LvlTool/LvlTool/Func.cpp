#include "Func.h"

long getTmpIndex(wxListView* List, long index)
{
	if (List->GetFocusedItem() == -1)
	{
		return index - 1;
	}
	else
	{
		return List->GetFocusedItem();
	}
}