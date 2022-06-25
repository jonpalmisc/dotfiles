from typing import Union

from binaryninja import *
from binaryninjaui import (
    UIActionContext,
    UIActionHandler,
    UIContext,
    DockHandler,
    HighlightTokenState,
)


def jp_get_data_vars(bv: BinaryView, query: Union[str, Type]):
    """Get all of the data variables matching the given type."""

    if isinstance(query, Type):
        type = query
    else:
        type, _ = bv.parse_type_string(query)

    result = []
    for var in bv.data_vars.values():
        if var.type != type:
            continue

        result.append(var)

    return result


def jp_hlil_report(func: Function):
    """Show the HLIL debug report for a function."""

    func.request_debug_report("high_level_il")


# ===------------------------------------------------------------------------===


def jp_ui_run_action(name: str):
    """Execute an action by name."""

    root = DockHandler.getActiveDockHandler().parent()
    ah = UIActionHandler().actionHandlerFromWidget(root)

    execute_on_main_thread(lambda: ah.executeAction(name))


def jp_ui_action_context() -> UIActionContext:
    """Get the current UI action context."""

    ui = UIContext.activeContext()
    ah = ui.contentActionHandler()
    return ah.actionContext()


def jp_ui_selection() -> HighlightTokenState:
    """Get the current selection from the UI."""

    ac = jp_ui_action_context()
    return ac.token
