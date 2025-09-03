package org.cdlib.xtf.textIndexer;


/**
 * Copyright (c) 2004, Regents of the University of California
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * - Neither the name of the University of California nor the names of its
 *   contributors may be used to endorse or promote products derived from this
 *   software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
import java.util.LinkedList;
import java.util.List;
import java.util.Stack;

////////////////////////////////////////////////////////////////////////////////

/**
 * This class maintains information about the current nesting of sections
 * in a text document that the TextIndexer program is processing. <br><br>
 *
 * On-line documents are stored as "nodes" in XML files that contain information
 * about the document, and the document text itself. The nodes usually form
 * a heirarchical tree structure, with the outer-most nodes recording
 * various bits of information about the text within. Inside the outer nodes
 * are additional nodes that record the organization of the text itself,
 * including things like section, chapter, and paragraph information. To the
 * text indexer program and search engine, sections have special significance.
 * Text in two adjacent sections that have different names, are considered
 * to not be "near" one another, so that proximity searches will not produce
 * results that span across two or more sections. <br><br>
 *
 * Since sections can be nested inside one-another, a stack of the current
 * nesting level needs to be maintained by the text indexer when a document
 * is being processed. Doing so does two things: <br><br>
 *
 * - It allows unnamed inner sections to inherit properties from the parent
 *   sections that contain them. <br>
 * - When the end of an named section has been reached, the text indexer can
 *   return to using the parent section's properties and continue processing.
 *   <br><br>
 *
 * The <code>SectionInfoStack</code> class is used to maintain the current
 * state of nested sections encountered in a document by the text indexer,
 * while the {@link org.cdlib.xtf.textIndexer.SectionInfo} class holds
 * the section attributes for each entry in the current stack. <br><br>
 *
 */
public class SectionInfoStack 
{
  /** Actual generic stack that holds the
   *  {@link org.cdlib.xtf.textIndexer.SectionInfo} objects.
   */
  private final Stack<SectionInfo> infoStack = new Stack<>();
  
  /** Top-level list of meta-data */
  private final List<MetaField> defaultMetaInfo = new LinkedList<>();
  
  public SectionInfoStack()
  {
    push();
    top().depth = Integer.MAX_VALUE / 2; // It can never be popped past
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////////////////

  /** Implicit depth-push operator. <br><br>
   *
   *  Call this method to push a section onto the stack with all the same
   *  attributes as the previous section. This method uses the
   *  {@link org.cdlib.xtf.textIndexer.SectionInfo#depth depth} field of the
   *  {@link org.cdlib.xtf.textIndexer.SectionInfo} class to maintain the
   *  correct depth for nested sections with identical attributes while avoiding
   *  pushing entire duplicate entries. <br><br>
   *
   *  @.notes Use the valuesChanged()
   *  method to determine if your attributes for a new section are identical to
   *  the section currently at the top of the stack before calling this method.
   *  Alternately, you can simply pass your new attributes to the
   *  explicit section-push operator,
   *  which performs the same check internally and calls this method as needed.
   *  <br><br>
   *
   */
  public void push() 
  {
    // If there's nothing on the stack, push a default section info structure.
    if (isEmpty()) 
    {
      // As a default, push a new section with initial depth of zero, the
      // index flag set to "true", no section bump, a word bump of one, no
      // no word boost, and a sentence bump of 5.
      //
      SectionInfo initialSec = new SectionInfo();
      initialSec.metaInfo = defaultMetaInfo;
      push(initialSec);
      return;
    }

    // Something's on the stack, so increment it's depth.
    top().depth++;
  } // public push()

  //////////////////////////////////////////////////////////////////////////////

  /** Section de-stacking operator. <br><br>
   *
   *  Call this method to pop a section off the nesting stack. <br><br>
   *
   *  @.notes Internally, this method decrements the depth of the topmost entry
   *          in the stack, and if the depth goes to zero, it removes the
   *          topmost entry from the stack. <br><br>
   *
   *          This method does nothing if there nesting stack is empty.
   */
  public void pop() 
  {
    // If there's nothing on the stack to pop, we're done.
    if (isEmpty())
      return;

    // Assume we don't need  to restore the previous section bump.
    boolean restorePrevSectionBump = top().sectionBump != 0;

    // If the accumulated section bump didn't get used in the current
    // section, we must restore the section bump for the previous section.
    //

      // Actually pop the top item off the section info stack.
    if (--(top().depth) == -1)
      infoStack.pop();

    // If there's nothing left on the stack, we're done.
    if (isEmpty())
      return;

    // If we need to restore the previous section's bump value, do so.
    if (restorePrevSectionBump)
      top().restoreSectionBump();
  } // pop()

  //////////////////////////////////////////////////////////////////////////////

  /** Return a reference to the section currently at the top of the nesting
   *  without popping the stack.
   *  <br><br>
   *
   *  @return  A reference to the top entry in the nesting stack.
   *
   */
  public SectionInfo peek() {
    return top();
  }

  //////////////////////////////////////////////////////////////////////////////

  /** Return a reference to the section just below the current one.
   *  <br><br>
   *
   *  @return  A reference to the second-from-top entry in the nesting stack.
   *
   */
  public SectionInfo prev() {
    // If the stack is empty, there is no prev.
    SectionInfo theTop = top();
    if (theTop == null)
      return null;
    
    // If the top element is already duped, there is no change.
    if (theTop.depth > 0)
      return theTop;

    // Otherwise up-cast a reference to the previous thing on the stack.
    return infoStack.elementAt(infoStack.size() - 1);
  }

  //////////////////////////////////////////////////////////////////////////////

  /** Query method to determine if there are any nested sections currently on
   *  the nesting stack. <br><br>
   *
   *  @return <code>true</code> - No nested sections currently on the stack.
   *                              <br>
   *          <code>false</code> - One or more nested sections are currently
   *                               on the stack. <br><br>
   */
  public boolean isEmpty() {
    return infoStack.isEmpty();
  }

    //////////////////////////////////////////////////////////////////////////////

    public List<MetaField> metaInfo()
  {
    // If the stack is empty, use the default list.
    if (isEmpty())
      return defaultMetaInfo;

    // Otherwise return the actual meta-info for the top entry.
    return top().metaInfo;
  }

  //////////////////////////////////////////////////////////////////////////////

  /** Return the section type name for the top section on the nesting stack.
   *  <br><br>
   *
   *  @return  Returns the name of the top section entry on the stack (if any)
   *           or an empty string if no type name is assigned or the stack is
   *           empty. <br><br>
   *
   *  @.notes
   *  For a complete explanation of the <code>sectionType</code> attribute, see
   *  the {@link org.cdlib.xtf.textIndexer.SectionInfo#sectionType sectionType}
   *  field in the {@link org.cdlib.xtf.textIndexer.SectionInfo} class. <br><br>
   */
  public String sectionType() 
  {
    // If the stack is empty, return the default (empty) type name.
    if (isEmpty())
      return SectionInfo.defaultSectionType;

    // Otherwise, return the actual type name from the top entry.
    return top().sectionType;
  } // sectionType()

  //////////////////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////////////////


    /** Push a {@link org.cdlib.xtf.textIndexer.SectionInfo} instance onto the
   *  top of the section stack. <br><br>
   *
   *  @.notes
   *  This method is a convenience function that does the necessary down-
   *  casting to have the generic stack object take a <code>SectionInfo</code>
   *  instance.
   *
   */
  private void push(SectionInfo info) {
    infoStack.push(info);
  }

  //////////////////////////////////////////////////////////////////////////////

  /** Return a reference to the top entry in the section stack, if any.
   *  <br><br>
   *
   *  @return  A reference to the top item in the section info stack, or
   *           <code>null</code> if the stack is empty.
   *
   *  @.notes
   *  This method is a convenience function that does the necessary up-
   *  casting to have the generic stack object return a <code>SectionInfo</code>
   *  instance.
   *
   */
  private SectionInfo top() 
  {
    // If the stack is empty, say so.
    if (isEmpty())
      return null;

    // Otherwise up-cast a reference to whatever is at the top of the stack.
    return infoStack.peek();
  } // top()
} // class SectionInfoStack
