class TaskStatus:
    RUNNING = 1
    SUCCESS = 2
    FAIL = 3


class BaseNode(object):
    def run(self):
        raise NotImplementedError


class BehaviorTypeNode(BaseNode):
    """
    Base class
    """
    def __init__(self):
        self._children = []
        self.child_index = 0

    def add_child(self, c):
        self._children.append(c)
        return self

    def get_next_child(self):
        try:
            child = self._children[self.child_index]
            self.child_index += 1
            return child
        except:
            return None


class TaskNode(BaseNode):
    pass


class SelectorTypeNode(BehaviorTypeNode):
    """
    Selector type node
    """
    def __init__(self):
        super(SelectorTypeNode, self).__init__()

    def run(self):
        result = False
        child = self.get_next_child()

        while child is not None:
            result = child.run()

            if result == TaskStatus.FAIL:
                child = self.get_next_child()
            elif result == TaskStatus.SUCCESS:
                break
            else:
                pass

        return result


class SequenceTypeNode(BehaviorTypeNode):
    """
    Sequece type node
    """
    def __init__(self):
        super(SequenceTypeNode, self).__init__()

    def run(self):
        result = True
        child = self.get_next_child()

        while child is not None:
            result = child.run()

            if result == TaskStatus.SUCCESS:
                child = self.get_next_child()
            elif result == TaskStatus.FAIL:
                break
            else:
                pass

        return result

class DecoratorTypeNode(BehaviorTypeNode):
    """
    Decorator type node
    """
    def __init__(self):
        super(DecoratorTypeNode, self).__init__()

    def run(self):
        child = self.get_next_child()
        result = child.run()
        if result == TaskStatus.SUCCESS:
            result = TaskStatus.FAIL
        else:
            result = TaskStatus.SUCCESS
        
        return result