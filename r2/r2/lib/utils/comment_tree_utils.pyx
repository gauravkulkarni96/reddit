# The contents of this file are subject to the Common Public Attribution
# License Version 1.0. (the "License"); you may not use this file except in
# compliance with the License. You may obtain a copy of the License at
# http://code.reddit.com/LICENSE. The License is based on the Mozilla Public
# License Version 1.1, but Sections 14 and 15 have been added to cover use of
# software over a computer network and provide for limited attribution for the
# Original Developer. In addition, Exhibit A has been modified to be consistent
# with Exhibit B.
#
# Software distributed under the License is distributed on an "AS IS" basis,
# WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
# the specific language governing rights and limitations under the License.
#
# The Original Code is reddit.
#
# The Original Developer is the Initial Developer.  The Initial Developer of
# the Original Code is reddit Inc.
#
# All portions of the code written by reddit are Copyright (c) 2006-2015 reddit
# Inc. All Rights Reserved.
###############################################################################

def get_num_children(list comments, dict tree):
    """Count the number of children for each comment."""

    cdef:
        dict num_children = {}
        list stack = []
        list children = []
        list missing = []
        long comment
        long current
        long child

    for comment in sorted(comments):
        stack.append(comment)

    while stack:
        current = stack[-1]

        if current in num_children:
            stack.pop()
            continue

        children = tree.get(current, [])

        for child in children:
            if child not in num_children and not tree.get(child, None):
                num_children[child] = 0

        missing = [child for child in children if not child in num_children]

        if not missing:
            num_children[current] = 0
            stack.pop()
            for child in children:
                num_children[current] += 1 + num_children[child]
        else:
            stack.extend(missing)

    return num_children


def get_tree_details(dict tree):
    cdef:
        list cids = []
        dict depth = {}
        dict parents = {}
        list child_ids

    for parent_id in sorted(tree):
        child_ids = tree[parent_id]

        cids.extend(child_ids)

        parents.update({child_id: parent_id for child_id in child_ids})

        child_depth = depth.get(parent_id, -1) + 1
        depth.update({child_id: child_depth for child_id in child_ids})

    return cids, depth, parents
